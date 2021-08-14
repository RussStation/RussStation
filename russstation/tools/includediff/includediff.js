const { readFileSync } = require("fs");
const { EOL } = require("os");
const { resolve } = require("path");

const delim = `${EOL}  `;

const tgIncludes = getIncludesFromFile("tgstation.dme");
const rsIncludes = getIncludesFromFile("RussStation.dme");

const tgUnique = tgIncludes.filter(path => !rsIncludes.includes(path));
const rsUnique = rsIncludes.filter(path => !tgIncludes.includes(path));

console.log(`\
/tg/station unique includes:
  ${tgUnique.join(delim)}

RussStation unique includes:
  ${rsUnique.join(delim)}`)

function getIncludesFromFile(fileName) {
	return readFileSync(resolve(fileName), { encoding: "utf8" })
    	.split(/\r?\n/)
    	.filter(str => str.startsWith("#include"))
    	.map(str => str.substring(10, str.length - 1));
}
