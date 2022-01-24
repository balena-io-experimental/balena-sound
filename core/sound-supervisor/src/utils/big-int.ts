export function BigIntParse(value: any): string {
	return JSON.parse(
		JSON.stringify(value, (_, v) => (typeof v === 'bigint' ? `${v}n` : v)),
	);
}
