
export function matchesInList(str: string, list: RegExp[]) {
	return list.reduce((prev, re) => prev || re.test(str), false)
}
