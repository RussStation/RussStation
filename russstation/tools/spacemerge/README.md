# spacemerge

The original Spacemerge process has been converted to a python script that automates even more of the process. Script will make assumptions on what can be safely git checked out so that only select files need to be manually resolved when merging between RussStation and /tg/station.

## why

RussStation and /tg/station's respective commit histories are unrelated. Within that, git has to scan the files directly to check for conflicts. Any difference, including line endings, will cause the file to be marked as conflicting. This leads to a *significant* number of conflicting files. To make keeping /tg/station upstream of RussStation feasible, this tool has been built to offload as much of the work resolving merge conflicts to an automated process as possible.

## how

Run `spacemerge.py` with a bash compatable terminal from the root directory of this repo. GitPython required, install with `pip install GitPython`.

The script can be configured via the string lists at the beginning of the file. Values that are expected to change eventually are `ours`, `theirs`, `our_dirs`, and `their_dirs`. The paths specified will be merged by taking all changes from either our side or theirs respectively.

For the script to run correctly, `last_merge` needs to exist in the repo root. This file should contain a unix timestamp, and specifies the point in time before which we can safely ignore changes as they've been resolved in previous merges. This will get updated when the script is run.

Script will output status updates on the steps it takes, and extra detail can be shown via `-v` verbose flags. Other options may be available, check `-h` help command. If the script experiences a fatal error, you should be able to just rerun it. At the end, the repo index will be left with all automated merges stages and leave unstaged anything that needs manual review. Script may also report other files to review that aren't processed the same way.
