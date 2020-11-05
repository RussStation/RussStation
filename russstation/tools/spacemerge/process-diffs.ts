import { execSync } from "child_process";
import { readFileSync } from "fs";
import getStdin from "get-stdin";

import { mergeStrategies, CommentPatterns } from "./config";
import { scrubConflicts } from "./scrub-conflicts";
import { matchesInList } from "./util";

let inputBuf: string = "";

// Map<string, string => () => void>
const strategies = new Map<string, (path: string) => () => void>([
	["THEIRS", makeTheirsHandler],
	["OURS", makeOursHandler],
	["CHECK", makeCheckHandler]
]);

(async () => {
	const input = await getStdin();

	input.split("\n")
        .map(getActionFromPath)
        .forEach(handler => handler());
})();

function getActionFromPath(path: string): () => void {
	for (let [match, strategy] of Object.entries(mergeStrategies)) {
		if (path.startsWith(match)) {
			const action = strategies.get(strategy);
			
			if (action !== undefined) {
				return action(path);
			} else {
				return makeUncaughtStrategyHandler(strategy, path);
			}
		}
	}

	return makeUncaughtPathHandler(path);
}

function makeUncaughtPathHandler(path: string) {
	return () => {} // noop
}

function makeUncaughtStrategyHandler(strategy: string, path: string) {
	return () => {
		console.error(`Couldn't find strategy: ${strategy} associated with path: ${path}`);
	}
}

function makeTheirsHandler(path: string) {
	return () => {
		checkout(path, false);
	};
}

function makeOursHandler(path: string) {
	return () => {
		checkout(path, true);
	};
}

function makeCheckHandler(path: string) {
	return () => {
		const contents = readFileSync(path, { encoding: "utf8" });
		
		if (matchesInList(contents, CommentPatterns)) {
			scrubConflicts(contents, path);
		} else { 
			checkout(path, false);
		}	
	};
}

function checkout(path: string, isOurs: boolean) {
	const side = isOurs ? "ours" : "theirs";

    execSync(`git checkout --${side} "${path}"`, { cwd: process.cwd(), encoding: "utf8", stdio: ["ignore", process.stdout, process.stderr] });
}
