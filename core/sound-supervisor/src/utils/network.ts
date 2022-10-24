import * as os from 'os';

export function getIPv4Address(): string {
	const networkInterfaces: NodeJS.Dict<os.NetworkInterfaceInfo[]> =
		os.networkInterfaces();
	const addresses: string[] = Object.keys(networkInterfaces)
		.filter((i) => i.includes('wlan') || i.includes('eth'))
		.map((i) => networkInterfaces[i])
		.flat()
		.filter((i) => i !== undefined && !i.internal && i.family === 'IPv4')
		.map((i) => i!.address);

	if (addresses.length === 0) {
		throw new Error('No IPv4 address found');
	}
	return addresses[0];
}
