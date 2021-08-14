
export const mergeStrategies: Record<string, string> = {
    "tools": "THEIRS",
    "tgui": "THEIRS",
    "SQL": "THEIRS",
    "sound": "THEIRS",
    "russstation": "OURS",
    "interface": "THEIRS",
    "icons": "THEIRS",
    "config": "OURS",
    "code": "CHECK",
	"_maps": "THEIRS",
	".github": "OURS"
};

export const CommentPatterns: RegExp[] = [
	/(\/\/|\/\*)[t\f\v ]*honk/i,
	/honk.*\*\//i
];
