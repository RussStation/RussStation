const { readFileSync, readdirSync } = require("fs");
const { join, relative } = require("path");
const { exec } = require("child_process");
const chalk = require("chalk");
const argm = require("minimist")(process.argv.slice(2)); // --verbose --close-on-error -h --help
const ms = require("./mergestrategies.json");

// The strategies to be used by mergestrategies.json
const strategies = {
    "OURS": folder => [ `git checkout --ours ${folder}/*` ],
    "THEIRS": folder => [ `git checkout --theirs ${folder}/*` ],
    "CHECK": getCheckedFileCheckouts
};

init(); // call entry point

/**
 * Entry point
 */
function init() {
    if (argm["h"] || argm["help"]) {
        console.log(
`Usage: spacemerge [options]

Options:
  --verbose           output all responses from git
  --close-on-error    stop processing git checkouts and exit if one fails
  -h, --help          display command line options (currently set)`);
        return;
    }

    const stratKVPairs = Array.from(Object.entries(ms));
    const commands = stratKVPairs.map(([key, value]) => strategies[value](key))
        .reduce((a, v) => [...a, ...v]);
    processCheckouts(commands);
}

/**
 * Takes a list of git commands and consumes them sequentially. They are
 * processed in sequence because git does not allow multiple git processes
 * to operate on the same repo at the same time.
 * @param {string[]} commands - A list of git commands to be executed
 * @param {Error} error - Supplied by the callback to child_process.exec 
 * see https://nodejs.org/docs/latest/api/child_process.html#child_process_child_process_exec_command_options_callback for details.
 * This and the following two parameters should be able to be safely ignored in external use
 * @param {string|Buffer} stdout - see above
 * @param {string|Buffer} stderr - see above
 */
function processCheckout(commands, error, stdout, stderr) {
    if (error) {
        console.log(chalk.black.bgRed(error));
        if (argm["close-on-error"]) return; //if --close-on-error is specified, and there is an error, break the recursion
    }
    if (stdout && argm["verbose"]) console.log(stdout);
    const next = commands.length === 1 ? undefined : processCheckout.bind(undefined, commands) // if this is the last one, supply no callback and break out of the recursion
    exec(commands.shift(), { cwd: process.cwd() }, next);
}

/**
 * Generates a list of git commands to checkout the files returned from getAllConflictedFilesNoHonk
 * @param {string} folder - The path to the folder to be scanned
 * @return {string[]} A list of the git commands to checkout the files that pass the filter
 */
function getCheckedFileCheckouts(folder) {
    return getAllConflictedFilesNoHonk(folder)
        .map(file => `git checkout --theirs ${relative(process.cwd(), file)}`);
}

/**
 * Syncronously scans a folder and all subfolders for DM files that contain the
 * git merge conflict delineator but do not contain a honk comment as specified in russstation/README.md
 * @param {string} folder - The path to the folder to scan
 * @returns {string[]} A list of paths of all the files that passed the filter
 */
function getAllConflictedFilesNoHonk(folder) {
    const filtered = [];
    for (let file of getAllDMFiles(folder)) {
        const contents = readFileSync(file); // slow
        if (!isConflicted(contents)) continue;
        if (isHonk(contents)) continue; // also slow
        filtered.push(file);
    }
    return filtered;
}

/**
 * Checks a string for the "Current Change" delineator used by git in merge conflicts
 * @param {string} body - the text to be checked against 
 * @returns {boolean}
 */
function isConflicted(body) {
    return body.includes("<<<<<<<");
}

/**
 * Checks a string for a honk comment as specified in russstation/README.md
 * @param {string} body - The text to be checked against
 * @returns {boolean}
 */
function isHonk(body) {
    return /(\/\/|\/\*)[t\f\v ]*honk/.test(body);
}

/**
 * Synchronously scans a folder and all sub folders for DM files and returns them in a list
 * @param {string} folder - The path to the folder to be scanned for DM files
 * @returns {string[]} - A list of the DM files inside the provided folder, including subdirectories
 */
function getAllDMFiles(folder) {
    const files = [];
    for (let file of readdirSync(folder, { withFileTypes: true })) {
        if (file.isDirectory()) {
            files.push(...getAllDMFiles(join(folder, file.name)));
        } else if (file.isFile() && file.name.endsWith(".dm")) {
            files.push(join(folder, file.name));
        }
    }
    return files;
}