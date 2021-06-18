#!/usr/bin/env python3
# space merge 2
# run from git root, don't interrupt or files will corrupt.
# if failure does happen, rerun in place- it will clean up and start fresh.
# automates as much as possibly can be.
# tried to be consistent with var naming:
#     "path" is a string describing the relative location on disk of a file
#     "file" is an object with more data about a path such as text content
#     "ours" prefixes anything that belongs to us or our local index
#     "theirs" prefixes anything that belongs to upstream or their index
# GitPython doesn't support all possible commands/flags so the repo.git calls are "manual" operations (usually more straightforward too...)

# imports - may need to pip install GitPython for git library

import argparse # for pretty command line interface
import datetime # for date/string conversion
import functools # for custom list sort comparison
import git # this is a git tool ya dingdong
import os # for some file operations
import re # for parsing strings like a sane person
import subprocess as sp # for process piping that gitpython doesn't handle
import sys # for printing stack traces in exceptions (needed?)
import time # for timing script execution

# config/globals - tried to restrict this to values that won't change during execution

# i don't expect these to get modified, but this avoids littering hard code
upstream = "tgstation"
upstream_branch = upstream + "/master"
their_dme = "tgstation.dme"
our_dme = "RussStation.dme"
epoch_path = "last_merge"
build_path = "tools/build/build.js"
# files to skip parsing and take ours or theirs
ours = ["html/changelog.html",
	"html/changelogs/.all_changelog.yml",
	"html/templates/header.html",
	"README.md",
	#".travis.yml",
	".github/ISSUE_TEMPLATE/bug_report.md",
	".github/ISSUE_TEMPLATE/feature_request.md"]
# .gitattributes is theirs but handled special to avoid git problems
theirs = [".editorconfig",
	"tgstation.dme"]
# dirs processed after individual files
our_dirs = [".github",
	"config",
	"russstation"]
# theirs previously included _maps and tgui; we keep maps and local UI tweaks in those so process them
their_dirs = ["icons",
	"interface",
	"sound",
	"SQL",
	"tools"]
# binary files break the parser so please exclude them
binaries = ["*.dmm",
	"*.dmi",
	"*.dll",
	"*.ogg",
	"*.exe",
	"*.png"]
sha1_check = re.compile(r"^[0-9a-f]{40}")
honk_check_pattern = r"((//|\\\\|/\*).*?honk|honk.*?\*/)" # why are // and \\ both legal comments in DM
honk_check = re.compile(honk_check_pattern, re.IGNORECASE)
include_find = re.compile(r'#include\s*"(.*?)"')
verbose = 0 # counts verbosity level. i don't want to pass this around everywhere >:(

# functions

# for verbose printing
def printv(*args):
	if verbose > 0:
		# add a little indent to see sections easier
		print("|", *args)
# for very verbose printing
def printvv(*args):
	if verbose > 1:
		print("|", *args)

# fancy command line interface~
def get_args():
	parser = argparse.ArgumentParser(
		description = "Simplify merging upstream SS13 repository",
		epilog="Execute from root of repository. Script will merge upstream code and then perform numerous steps to resolve the heaping pile of merge conflicts. Attempts are made to automate as much as possible to reduce manual conflict resolution, but there's only so much the script can determine without a human brain. If script fails or needs to be interrupted rerun from the beginning."
	)
	parser.add_argument(
		"-v", "--verbose",
		action="count",
		help="Print more detail about script operation, can be repeated for more verbosity"
	)
	parser.add_argument(
		"-d", "--delete-all",
		action="store_true",
		help="Interactively delete removed files outside of upstream's directories"
	)
	parser.add_argument(
		"-t", "--target-time",
		metavar="DATETIME",
		help="Specify a date and time to merge up until instead of now, use an ISO time format"
	)
	parser.add_argument(
		"-f", "--file",
		help="Process a single file (mostly for testing)"
	)
	parser.add_argument(
		"--dme",
		action="store_true",
		help="Fix DME includes in case file changes weren't handled by VS Code extension"
	)
	return parser.parse_args()

# get a clean master to branch from
def clean_state(repo):
	print("Cleaning working tree...")
	repo.head.reset(working_tree=True)
	repo.git.clean("-f", "-d", "-x")
	printv("Cleaned index")
	repo.heads.master.checkout()
	printv("Checked out master")

# fetch and create branch
def create_branch(repo, target_time):
	print("Creating merge branch...")
	repo.remotes.origin.fetch()
	repo.remotes[upstream].fetch()
	printv("Fetched origin and upstream")
	# TODO target time merge maybe isn't working, was missing commits in the time range when testing
	name = "upstream-merge-" + (datetime.datetime.fromisoformat(target_time) if target_time else datetime.datetime.now()).strftime("%y%m%d")
	if name in repo.heads:
		repo.delete_head(name, "-D")
		printv("Deleted old merge branch", name)
	repo.create_head(name, repo.heads.master) # maybe should be repo.remotes.origin.refs.master
	printv("Created branch", name)
	repo.heads[name].set_tracking_branch(repo.remotes.tgstation.refs.master)
	repo.heads[name].checkout()
	printv("Checked out branch", name)

# get time as a unix epoch, doesn't need quoted
def get_merge_times(repo, target_time):
	# the "smart" solution is wrong, because the timestamp will reflect the time of PR merge:
	#     return repo.git.log("-1", "--format=%ct", their_dme)
	# instead store the actual epoch of last merge so that it's guaranteed to be accurate
	current_merge = datetime.datetime.fromisoformat(target_time) if target_time else datetime.datetime.now()
	with open(epoch_path, "r") as file:
		last_merge = file.readline().strip()
		printv("Last merge was", last_merge, datetime.datetime.fromtimestamp(float(last_merge)).isoformat())
		return (last_merge, str(current_merge.timestamp())) # get current merge to commit later

# counterpart to get, wait until after merge to add the file change
def record_merge_time(repo, current_merge):
	# update merge tracking file
	with open(epoch_path, "w") as file:
		file.write(current_merge)
	repo.git.add(epoch_path)
	printv("Updated merge to", current_merge)

# hopefully this reduces how much needs processed
def merge_upstream(repo, target_time):
	print("Merging...")
	target_branch = upstream_branch
	if target_time:
		# specify time to merge from
		target_branch += "@{" + target_time + "}"
		printv("Merging upstream as it was at", target_time)
	try:
		repo.git.merge(target_branch, "--squash", "--allow-unrelated-histories", "-Xignore-space-at-eol", "-Xdiff-algorithm=histogram")
	except git.exc.GitCommandError as e:
		# expected because the merge will have conflicts
		if not "fix conflicts" in repr(e):
			raise e

# fix .git files immediately
def prepare_git_files(repo):
	# .gitattributes: just check if it's modified, then we'll take theirs
	if repo.git.status("-s", ".gitattributes"):
		repo.git.checkout(".gitattributes", "--theirs")
		repo.git.add(".gitattributes")
		printv("Checked out their .gitattributes")
	# .gitignore: take theirs then append ours
	if repo.git.status("-s", ".gitignore"):
		repo.git.checkout(".gitignore", "--theirs")
		printv("Checked out their .gitignore")
		with open("our.gitignore", "r") as ours, open(".gitignore", "a") as theirs:
			line = ours.readline()
			while line:
				theirs.write(line)
				line = ours.readline()
		repo.git.add(".gitignore")
		printv("Appended our.gitignore")

# the way we merge doesn't delete files that upstream deleted, find and delete them
# returns deleted honk files for warning at the end
def remove_deleted_files(repo, delete_all):
	print("Removing undeleted upstream files...")
	our_extant_paths = set(repo.git.ls_tree("-r", "--name-only", "HEAD").splitlines())
	their_extant_paths = set(repo.git.ls_tree("-r", "--name-only", "refs/remotes/" + upstream_branch).splitlines())
	# if any honk files would get deleted, we will warn the user
	honk_paths = get_honk_files(repo)
	# we want files that exist in our index but not upstream
	deleted_paths = our_extant_paths - their_extant_paths - honk_paths
	deleted_honk_paths = (our_extant_paths - their_extant_paths).intersection(honk_paths)
	# upstream will delete files in dirs that are not safe to blindly delete all from (eg _maps has our maps too)
	if delete_all:
		# inform user of how delete-all behavior works so i can use y/n prompts
		print("Delete all enabled. Files outside of their dirs will each prompt for deletion")
		print("Type y for yes, n (or nothing) for no, q to quit deleting all; then enter")
	for path in deleted_paths:
		is_theirs = False
		for dir in their_dirs:
			if path.startswith(dir + "/"):
				is_theirs = True
				# rm -f removes from working tree and index (index removal when committed)
				if os.path.isfile(path):
					repo.git.rm("-f", path)
					printvv(path, "removed from working tree and index")
				break
		if not is_theirs and delete_all:
			is_ours = False
			for dir in our_dirs:
				# skip stuff in our dirs
				if path.startswith(dir + "/"):
					is_ours = True
					break
			if not is_ours and os.path.isfile(path):
				delete_all = delete_prompt(repo, path)
	# warn about deleted honks (probably moved files)
	if len(deleted_honk_paths) > 0:
		print("Checking deleted files that need attention...")
		for path in deleted_honk_paths:
			printv(path, "was deleted upstream but contains honk comments, recommend reviewing for moved file")
			# is this a good idea? it *is* interactive, no harm in asking?
			if delete_all:
				delete_all = delete_prompt(repo, path)
	return deleted_honk_paths

# tried to make a nice interactive prompt for manual deletions
# returns False if user wants to quit delete-all mode
def delete_prompt(repo, path):
	while True:
		permission = input("Delete file " + path + "? (y/N/q/?) ")
		if permission.lower() == "y":
			repo.git.rm("-f", path)
			return True
		elif permission.lower() == "n" or not permission:
			return True
		elif permission.lower() == "q":
			return False
		# conditions that stay in the loop to get a good input
		elif permission == "?":
			print("Type y for yes, n (or nothing) for no, or q to quit deleting all; then enter.")
		else: # what did you type??
			print("Unknown value", permission)

# handle some stuff before process loop so it's a bit msmoother
def preprocess_checkouts(repo):
	print("Checking out files that don't need processed...")
	for filename in ours:
		repo.git.checkout(filename, "--ours")
		repo.git.add(filename)
		printvv("Checked out our", filename)
	for filename in theirs:
		repo.git.checkout(filename, "--theirs")
		repo.git.add(filename)
		printvv("Checked out their", filename)
	for dirname in our_dirs:
		repo.git.checkout(dirname, "--ours")
		repo.git.add(dirname)
		printvv("Checked out our", dirname + "/*")
	for dirname in their_dirs:
		repo.git.checkout(dirname, "--theirs")
		repo.git.add(dirname)
		printvv("Checked out their", dirname + "/*")
	for ext in binaries:
		repo.git.checkout(ext, "--theirs")
		repo.git.add(ext)
		printvv("Checked out their", ext)

# get a list of files that were updated upstream
def get_upstream_updated_paths(repo, last_merge, current_merge):
	print("Retrieving updated file list...")
	long_paths = repo.git.log("--after=" + last_merge, "--until=" + current_merge, "--remotes=" + upstream, "--name-only", "--pretty=oneline")
	# raw output contains duplicates and lines starting with the commit hash, we don't want those
	only_paths = [path for path in long_paths.splitlines() if path and not sha1_check.match(path)]
	updated_paths = set(only_paths)
	printv(len(updated_paths), "files updated since last merge")
	return updated_paths

# get the list of files that have honk comments
def get_honk_files(repo):
	# -I ignore binary, -i case insenstive, -l filename instead of matched lines, -E extended regex, -e pattern is next parameter
	honk_paths = set(repo.git.grep("-IilEe", honk_check_pattern).splitlines())
	printv("Retrieved list of files with honk comments")
	return honk_paths

# get conflicted files, process em, revert unchanged conflicts
def process_conflicts(repo, upstream_paths):
	print("Processing files...")
	# U for unmerged ie conflicted
	conflict_paths = set(repo.git.diff("--name-only", "--diff-filter=U").splitlines())
	printv(len(conflict_paths), "unmerged files")
	honk_paths = get_honk_files(repo)
	# the paths we will process are unmerged, have honk comments, and were changed upstream
	process_paths = conflict_paths.intersection(upstream_paths).intersection(honk_paths)
	printv(len(process_paths), "files to process")
	for path in process_paths:
		try:
			resolve_conflicts(repo, path)
		except:
			printv("Failed processing on", path)
			printv("Exception:", sys.exc_info())
	# paths that weren't changed upstream need reverted
	print("Reverting unchanged files...")
	revert_paths = conflict_paths - upstream_paths
	printv(len(revert_paths), "unchanged files to revert")
	for path in revert_paths:
		try:
			# why doesn't git have a single operation for unstage and discard
			printvv("Reverting", repo.git.status("-s", path))
			repo.git.restore(path, "--staged")
			repo.git.restore(path)
		except git.exc.GitCommandError as e:
			# git restore fails if file doesn't exist because it was git removed
			printv("Couldn't revert", path)
			printv(repr(e))
	# remaining files just checkout theirs
	print("Resolving remaining conflicts...")
	their_paths = conflict_paths.intersection(upstream_paths) - honk_paths
	printv(len(their_paths), "remaining conflicted files")
	for path in their_paths:
		try:
			repo.git.checkout("--theirs", path)
			repo.git.add(path)
			printvv("Checked out their", path)
		except:
			printv("Failed to checkout their", path)
	# any remaining modified files don't have conflicts, but may have honks
	# apparently Unmerged is a subset of Modified, so to add all the remaining files we need more set operations
	print("Resolving remaining nonconflicts...")
	modified_paths = set(repo.git.diff("--name-only", "--diff-filter=M").splitlines())
	true_modified_paths = modified_paths - conflict_paths
	modified_honk_paths = true_modified_paths.intersection(honk_paths)
	modified_their_paths = true_modified_paths - honk_paths
	for path in modified_honk_paths:
		# don't keep conflict sections during resolution
		resolve_conflicts(repo, path, keep_conflicts = False)
	for path in modified_their_paths:
		repo.git.checkout("--theirs", path)
		repo.git.add(path)
		printvv("Checked out their", path)

# find conflict section, inspect section based on rules, modify file, stage in git
def resolve_conflicts(repo, filename, keep_conflicts = True):
	stage = True
	temp_filename = filename + ".temp"
	with open(filename, "r") as conflict_file, open(temp_filename, "w") as processed_file:
		text_line = conflict_file.readline()
		while text_line:
			# parse for conflict section
			if text_line.startswith("<<<<<<<"):
				ours_buffer = [] # hold onto our code lines
				# found head of conflict, grab until diff divider
				contains_honk = False
				text_line = conflict_file.readline() # toss <<< line
				while not text_line.startswith("======="):
					ours_buffer.append(text_line)
					# check for honk comment presence in this section - re.search instead of .match to check entire string
					if not contains_honk and honk_check.search(text_line):
						contains_honk = True
					text_line = conflict_file.readline()
				text_line = conflict_file.readline() # dispose === line
				# if we found a match, print entire conflict unless theirs has a honk (upstream honk comment)
				theirs_buffer = [] # now hold theirs uwu
				upstream_honk = False
				while not text_line.startswith(">>>>>>>"):
					theirs_buffer.append(text_line)
					if not upstream_honk and honk_check.search(text_line):
						upstream_honk = True
					text_line = conflict_file.readline()
				# conflict resolution:
				# take theirs if they have a honk comment or we do not
				if upstream_honk or not contains_honk:
					for line in theirs_buffer:
						processed_file.write(line)
				# keep ours if no upstream code or we don't care about conflicts in this file
				elif len(theirs_buffer) == 0 or not keep_conflicts:
					for line in ours_buffer:
						processed_file.write(line)
				# keep both sides for review and print entire conflict section
				else:
					processed_file.write("<<<<<<< HEAD\n")
					for line in ours_buffer:
						processed_file.write(line)
					processed_file.write("=======\n")
					for line in theirs_buffer:
						processed_file.write(line)
					processed_file.write(">>>>>>> " + upstream_branch + "\n")
					stage = False
				text_line = conflict_file.readline() # discard >>> line
				continue
			# parsing finished, add line to file and continue
			processed_file.write(text_line)
			text_line = conflict_file.readline()
	# replace file with processed
	os.replace(temp_filename, filename)
	# mark staged in git
	if stage:
		repo.git.add(filename)
		printvv("Staged", filename)
	else:
		printvv("Conflict found in", filename)

# dme wants filesystem sort instead of raw string sort
def dme_sort_compare(left, right):
	# split paths to compare file and directory order appropriately
	# at the same depth, files come before directories
	# if both are files or both are directories, alphabet order
	# ! files compare extension then name
	# return negative for left < right, positive for left > right
	lefts = left.split("\\")
	rights = right.split("\\")
	# decrement depths for 0-based compares
	left_depth = len(lefts) - 1
	right_depth = len(rights) - 1
	# but then increment so the range goes far enough
	for i in range(min(left_depth, right_depth) + 1):
		l = lefts[i].lower()
		r = rights[i].lower()
		if i == left_depth and i < right_depth:
			# left is a file, right is a directory
			return -1
		elif i == right_depth and i < left_depth:
			# right is a file, left is a directory
			return 1
		elif l == r:
			# looking at same directory, go deeper
			continue
		elif i == left_depth and i == right_depth:
			# files compare extension first
			left_ext = l.split(".")[-1]
			right_ext = r.split(".")[-1]
			if left_ext != right_ext:
				return -1 if left_ext < right_ext else 1
			# else fall down to the full name compare
		# directory/filename compare - _ should be before letters but python doesn't do that
		return string_compare(l, r)

# string compare where _ is first
def string_compare(left, right):
	_left = left.startswith("_")
	_right = right.startswith("_")
	if _left and not _right:
		return -1
	elif not _left and _right:
		return 1
	elif _left and _right:
		return string_compare(left[1:], right[1:])
	else:
		return -1 if left < right else 1

# get unique includes from both dmes, combine
def update_includes(repo):
	preface = []
	their_includes = []
	our_includes = []
	print("Updating DME includes...")
	with open(their_dme, "r") as their_file:
		# get their includes
		text_line = their_file.readline()
		while text_line:
			# skip until includes
			if include_find.match(text_line):
				break
			else:
				text_line = their_file.readline()
		while text_line:
			match = include_find.match(text_line)
			if match:
				their_includes.append(match.group(1).strip())
				text_line = their_file.readline()
			else:
				break
	printv(len(their_includes), "their includes")
	with open(our_dme, "r") as our_file:
		# get our includes
		text_line = our_file.readline()
		while text_line:
			# store lines before includes to rebuild file
			match = include_find.match(text_line)
			if match:
				break
			else:
				preface.append(text_line)
				text_line = our_file.readline()
		while text_line:
			match = include_find.match(text_line)
			if match:
				our_includes.append(match.group(1).strip())
				text_line = our_file.readline()
			else:
				break
	printv(len(our_includes), "our includes")
	# combine without dupes, remove files that don't exist (leftover in our dme)
	new_includes = []
	for path in set(their_includes + our_includes):
		if os.path.isfile(path.replace("\\", "/")): # stupid wrong slashes in dme
			new_includes.append(path)
	new_includes.sort(key=functools.cmp_to_key(dme_sort_compare))
	printv(len(new_includes), "combined includes")
	# write file beginning then includes
	with open(our_dme, "w") as file:
		for line in preface:
			file.write(line)
		for path in new_includes:
			file.write('#include "' + path + '"\n')
		file.write("// END_INCLUDE\n")
	repo.git.add(our_dme)

# files will sneak past the .gitignore because git merge uses the wrong .gitignore before we can fix it
def unstage_ignored_files(repo):
	# have to do this with subprocess because gitpython doesn't have piping and the first result is too big to pass
	staged_files = sp.Popen(["git", "diff", "--name-only", "--cached", "--diff-filter=d"], text=True, stdout=sp.PIPE)
	ignored_files = sp.Popen(["git", "check-ignore", "--stdin", "--no-index"], text=True, stdin=staged_files.stdout, stdout=sp.PIPE)
	staged_files.wait()
	ignored_files.wait()
	ignored_paths, stderr = ignored_files.communicate()
	if len(ignored_paths):
		print("Unstaging files that evaded .gitignore...")
		printv(len(ignored_paths), "potential files should have been ignored")
		for path in ignored_paths.splitlines():
			if path and os.path.isfile(path):
				repo.git.rm("--cached", path)
				printvv(path, "removed from index")

# build script obviously needs to build our dme and not theirs
def fix_build_script(repo):
	print("Fixing build script...")
	build_content = None
	with open(build_path, "r") as build_file:
		build_content = build_file.read()
	# replace the dme var definition so it uses ours
	build_content = build_content.replace("DME_NAME = '" + their_dme[:their_dme.find(".dme")], "DME_NAME = '" + our_dme[:our_dme.find(".dme")])
	# add russstation folder to dm dependency list (ensures build retries if only our files change)
	build_content = build_content.replace(".depends('code/**')", ".depends('code/**')\n  .depends('russstation/**')")
	with open(build_path, "w") as build_file:
		build_file.write(build_content)
	repo.git.add(build_path)
	printv("Replaced build script vars")

# say anything that still needs said
def finish(repo, deleted_honks):
	remaining_conflicts = repo.git.diff("--name-only", "--diff-filter=U").splitlines()
	if remaining_conflicts:
		print("Merge completed, manually review", len(remaining_conflicts), "remaining conflicts")
	else:
		print("Merge completed, no conflicts remaining")
	if verbose > 0:
		# show conflicted files. not using printv to change indent character
		for path in remaining_conflicts:
			print("*", path)
	if deleted_honks:
		print("Found", len(deleted_honks), "files which do not exist upstream that have honk comments, please review for moved files")
		for path in deleted_honks:
			print("*", path)

# run the dang script
if __name__ == "__main__":
	args = get_args()
	repo = git.Repo(os.getcwd())
	verbose = args.verbose or 0
	# check that we're running at git root
	if not repo or repo.bare:
		print("Script must be run from git root")
	elif args.file:
		# single file testing
		resolve_conflicts(repo, args.file)
	elif args.dme:
		# just fix dme includes
		update_includes(repo)
	else:
		start = time.perf_counter()
		clean_state(repo)
		last_merge, current_merge = get_merge_times(repo, args.target_time) # grab time before merge for accuracy
		create_branch(repo, args.target_time)
		merge_upstream(repo, args.target_time)
		prepare_git_files(repo) # best to do immediately after merge to stop git complaints
		deleted_honks = remove_deleted_files(repo, args.delete_all)
		preprocess_checkouts(repo)
		# only process files that were changed upstream - skips files with conflicts we've previously solved
		upstream_paths = get_upstream_updated_paths(repo, last_merge, current_merge)
		process_conflicts(repo, upstream_paths)
		update_includes(repo)
		unstage_ignored_files(repo)
		fix_build_script(repo)
		record_merge_time(repo, current_merge)
		finish(repo, deleted_honks)
		end = time.perf_counter()
		printv("Execution took", end - start, "seconds")
