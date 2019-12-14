import { execSync } from "child_process";
import { readFileSync } from "fs";
import { mergeStrategies, honkRegex } from "./config";

let inputBuf: string = "";

// Map<string, string => () => void>
const strategies = new Map([
	["THEIRS", makeTheirsHandler],
	["OURS", makeOursHandler],
	["CHECK", makeCheckHandler]
]);

process.stdin.setEncoding("utf8");

process.stdin.on("readable", () => {
	let chunk: string | Buffer;
	while ((chunk = process.stdin.read()) !== null) inputBuf += chunk;
});

process.stdin.on("end", () => {
	inputBuf
        .split("\n")
        .map(getActionFromPath)
        .forEach(handler => handler());
});

function getActionFromPath(path: string): () => void {
	for (let [match, strategy] of Object.entries(mergeStrategies)) {
		if (path.startsWith(match)) {
			const action = strategies.get(strategy);
			if (action !== undefined) return action(path);
			else return makeUncaughtStrategyHandler(strategy, path)
		}
	}

	return makeUncaughtPathHandler(path);
}

function makeUncaughtPathHandler(path: string) {
	return () => {} // noop
}

function makeUncaughtStrategyHandler(strategy: string, path: string) {
	return () => {
		console.error(`Couldn't find strategy: ${strategy} associated with path: ${path}`)
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
		const contents = readFileSync(path, { encoding: "utf8"});
		if (!honkRegex.test(contents)) {
			checkout(path, false);
		}
	};
}

function checkout(path: string, isOurs: boolean) {
    execSync(`git checkout --${isOurs ? "ours" : "theirs"} ${path}`, { cwd: process.cwd(), encoding: "utf8", stdio: ["ignore", process.stdout, process.stderr] });
}
