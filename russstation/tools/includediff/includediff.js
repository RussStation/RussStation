const { readFileSync } = require("fs");
const { EOL } = require("os");

const tgIncludes = readFileSync(process.cwd() + "/tgstation.dme", { encoding: "utf8" })
    .split('\n')
    .filter(str => str.startsWith("#include"))
    .map(str => str.substring(8))

const rsIncludes = readFileSync(process.cwd() + "/RussStation.dme", { encoding: "utf8" })
    .split('\n')
    .filter(str => str.startsWith("#include"))
    .map(str => str.substring(8))

const tgUnique = tgIncludes.filter(path => !rsIncludes.includes(path));
const rsUnique = rsIncludes.filter(path => !tgIncludes.includes(path));

console.log("/tg/station unique includes:")
console.log(tgUnique)
console.log()

console.log("RussStation unique includes:")
console.log(rsUnique)