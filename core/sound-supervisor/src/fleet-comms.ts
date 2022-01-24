import * as cote from 'cote';
import { getIPv4Address } from './utils/network';

export type FleetEvent = 'fleet-update' | 'fleet-sync' | 'fleet-heartbeat';

export interface FleetHeartbeat extends cote.Event {
	origin: string;
}

export interface FleetUpdate extends cote.Event {
	master: string;
}

class FleetCommunicator {
	private discoveryOptions: cote.DiscoveryOptions = {
		log: false,
		helloLogsEnabled: false,
		statusLogsEnabled: false,
	};
	private publisher: cote.Publisher = new cote.Publisher(
		{ name: 'balenaSound publisher' },
		this.discoveryOptions,
	);
	private subscriber: cote.Subscriber = new cote.Subscriber(
		{ name: 'balenaSound subscriber' },
		this.discoveryOptions,
	);

	publish(event: FleetEvent, data: any) {
		this.publisher.publish(event, data);
	}

	on(event: FleetEvent, callback: (data: any) => void) {
		this.subscriber.on(event, callback);
	}

	startHeartbeat(interval: number) {
		this.publish('fleet-heartbeat', { origin: getIPv4Address() });

		setInterval(() => {
			this.publish('fleet-heartbeat', { origin: getIPv4Address() });
		}, interval);
	}

	onHeartbeat(callback: (data: FleetHeartbeat) => void) {
		this.subscriber.on('fleet-heartbeat', callback);
	}
}

export default new FleetCommunicator();
