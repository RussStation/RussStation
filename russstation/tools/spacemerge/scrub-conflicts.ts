import * as find from "find";
import { resolve } from "path";
import { readFile } from "fs";
import { EOL } from "os";

import { honkRegex } from "./config";

interface ConflictLines {
	start: number,
	mid: number | undefined,
	end: number | undefined
}

find.eachfile(/\.dm$/, resolve("code"), fileName => {
	readFile(fileName, "utf8", (err, data) => {
		if (err) console.error(err);
		const file = data.split(EOL);
		const conflictLinesList = getConflictLinesList(file);
		for (let conflictLines of conflictLinesList) {
			if (!oursHasHonkComment(file, conflictLines)) takeTheirs(file, conflictLines);
		}
		
	});
});

function oursHasHonkComment(file: string[], { start, mid = manditory<number>(0) }: ConflictLines) {
	return file
		.slice(start + 1, mid)
		.join(EOL)
		.match(honkRegex) !== null;
}

function takeTheirs(file: string[], { start, mid = manditory<number>(0), end = manditory<number>(0) }: ConflictLines) {
	file = [ 
		...file.slice(0, start),
		...file.slice(mid + 1, end),
		...file.slice(end + 1)
	];
}

function getConflictLinesList(file: string[]) {
	let current: ConflictLines | undefined;
	const conflicts: ConflictLines[] = [];
	for (let i = 0; i < file.length; i++) {
		if (file[i].startsWith("<<<<<<<") && !current) {
			current = { 
				start: i,
				mid: undefined,
				end: undefined
			};
		} else if (file[i].startsWith("=======") && current) {
			current.mid = i;
		} else if (file[i].startsWith(">>>>>>>") && current) {
			current.end = i;
			conflicts.push(current);
			current = undefined;
		}
	}

	return conflicts;
}

function manditory<T>(def: T) { // def is short for default
	throw new Error("Required argument was undefined");
	return def;
}
