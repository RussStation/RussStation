import { writeFileSync } from "fs";
import { EOL } from "os";

import { CommentPatterns } from "./config";
import { matchesInList } from "./util";

interface ConflictLines {
	start: number,
	mid: number,
	end: number
}

interface ConflictLinesBuilder {
	start: number,
	mid: number | undefined,
	end: number | undefined
}

export function scrubConflicts(data: string, path: string) {
	let file = data.split(/\r?\n/);
	let hasBeenScrubbed = false;

	let conflictLines = findConflictLines(file, path);
	while (conflictLines) {
		const { start, mid, end } = conflictLines;
		if (!oursHasFlagComment(file, conflictLines)) {
			file = takeTheirs(file, conflictLines);
			hasBeenScrubbed = true;
			conflictLines = findConflictLines(file, path, start + (end - (mid + 1)));
		} else {
			conflictLines = findConflictLines(file, path, end + 1);
		}
	}

	if (hasBeenScrubbed) {
		writeFileSync(path, file.join(EOL));
		console.log(`[SCRUB] ${path}`);
	} else {
		console.log(`[NOSCRUB] ${path}`)
	}
	
}

function oursHasFlagComment(file: string[], { start, mid }: ConflictLines) {
	const ours = file
		.slice(start + 1, mid)
		.join(EOL)

	return matchesInList(ours, CommentPatterns)
}

function takeTheirs(file: string[], { start, mid, end }: ConflictLines) {
	return [ 
		...file.slice(0, start),
		...file.slice(mid + 1, end),
		...file.slice(end + 1)
	];
}

function findConflictLines(file: string[], fileName: string, start = 0): ConflictLines | undefined {
	if (start >= file.length) return undefined;

	let current: ConflictLinesBuilder | undefined;

	for (let i = start; i < file.length; i++) {
		if (file[i].startsWith("<<<<<<<") && !current) {
			current = { 
				start: i,
				mid: undefined,
				end: undefined
			};
		} else if (file[i].startsWith("=======") && current) {
			current.mid = i;
		} else if (file[i].startsWith(">>>>>>>") && current && current.mid) {
			current.end = i;
			return {
				start: current.start,
				mid: current.mid,
				end: current.end
			}
		}
	}

	return undefined;
}
