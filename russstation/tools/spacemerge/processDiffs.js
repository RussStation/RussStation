const { execSync } = require("child_process");
const { readFileSync } = require("fs");
const strategyConfigs = require("./mergestrategies.json");

let inputBuf = "";

// Map<string, string => () => void>
const strategies = new Map([
	["THEIRS", makeTheirsHandler],
	["OURS", makeOursHandler],
	["CHECK", makeCheckHandler]
]);

process.stdin.setEncoding("utf8");

process.stdin.on("readable", () => {
	let chunk;
	while ((chunk = process.stdin.read()) !== null) inputBuf += chunk;
});

process.stdin.on("end", () => {
	const handlers = inputBuf
        .split("\n")
        .map(getActionFromPath)
        .filter(x => !!x)
        .forEach(handler => handler());
});

function getActionFromPath(path) {
	for (let [match, strategy] of Object.entries(strategyConfigs)) {
		if (path.startsWith(match)) return strategies.get(strategy)(path);
	}
}

function makeTheirsHandler(path) {
	return () => {
		checkout(path, false)
	};
}

function makeOursHandler(path) {
	return () => {
		checkout(path, true)
	};
}

function makeCheckHandler(path) {
	return () => {
		const contents = readFileSync(path);
		if (!/(\/\/|\/\*)[t\f\v ]*honk/i.test(contents)) {
			checkout(path, false);
		}
	};
}

function checkout(path, isOurs) {
    execSync(`git checkout --${isOurs ? "ours" : "theirs"} ${path}`, { cwd: process.cwd(), encoding: "utf8", stdio: ["ignore", process.stdout, process.stderr] });
}
