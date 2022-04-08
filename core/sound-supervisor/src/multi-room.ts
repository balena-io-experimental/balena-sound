import BalenaDevice from './balena/device';
import constants from './constants';

class MultiRoom {
	public enabled: boolean = !constants.multiroom.disable;
	public master: string = constants.multiroom.master ?? BalenaDevice.ip;
	public forced: boolean = constants.multiroom.forced;
	public disallowUpdates: boolean = constants.multiroom.disallowUpdates;

	isNewMaster(master: string) {
		return this.master !== master;
	}

	setMaster(master: string) {
		this.master = master;
	}
}

export default new MultiRoom();
