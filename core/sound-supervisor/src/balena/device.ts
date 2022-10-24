import { getIPv4Address } from '../utils/network';
import BalenaSupervisorRequest from './supervisor-request';

const MULTI_ROOM_BLACKLIST = ['raspberry-pi', 'raspberry-pi2', 'unknown'];
const ENDPOINT_SHUTDOWN = 'v1/shutdown';
const ENDPOINT_REBOOT = 'v1/reboot';
const ENDPOINT_RESTART = 'v1/restart';

class BalenaDevice {
	public ip: string;
	public type: string;
	public appId: string;
	public isMultiRoomCapable: boolean = false;

	constructor() {
		const { BALENA_DEVICE_TYPE, BALENA_APP_ID } = process.env;

		if (BALENA_DEVICE_TYPE === undefined || BALENA_APP_ID === undefined) {
			throw new Error(
				'BALENA_DEVICE_TYPE and BALENA_DEVICE_TYPE enviroment variables are required!',
			);
		}

		this.type = BALENA_DEVICE_TYPE;
		this.appId = BALENA_APP_ID;
		this.ip = getIPv4Address();
		this.isMultiRoomCapable = !MULTI_ROOM_BLACKLIST.includes(this.type);
	}

	reboot = () => new BalenaSupervisorRequest(ENDPOINT_REBOOT).execute();
	shutdown = () => new BalenaSupervisorRequest(ENDPOINT_SHUTDOWN).execute();
	restart = () =>
		new BalenaSupervisorRequest(ENDPOINT_RESTART, this.appId).execute();
}

export default new BalenaDevice();
