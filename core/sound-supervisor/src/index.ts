import constants from './constants';
import soundAPI from './sound-api';
import FleetComms, { FleetHeartbeat, FleetUpdate } from './fleet-comms';
import BalenaDevice from './balena/device';
import MultiRoom from './multi-room';
import AudioBlock, { upgradeToMultiRoom, printAudioInfo } from './audio-block';
import { BalenaService } from './balena/service';
import log from './logger';
import { BigIntParse } from './utils/big-int';

const logEvent = log.extend('event');
init();
async function init() {
	soundAPI.listen(constants.port, () => {
		log(`Sound supervisor listening on port ${constants.port}`);
	});

	await AudioBlock.listen();
	await AudioBlock.setVolume(
		constants.initVolume,
		constants.pulseAudio.inputSink,
	);
	await printAudioInfo();
	FleetComms.startHeartbeat(constants.multiroom.pollInterval);

	if (BalenaDevice.isMultiRoomCapable) {
		log('Device is multi-room capable, upgrading to multi-room mode');
		await upgradeToMultiRoom();
	}
}

// Event: 'play'
// Origin: audio block
// When playback starts on a device announce itself as the new master server
AudioBlock.on('play', (sink) => {
	logEvent(`play ${JSON.stringify(BigIntParse(sink))}`);

	if (
		sink.name === constants.pulseAudio.inputSink &&
		BalenaDevice.isMultiRoomCapable
	) {
		logEvent(
			`Playback started, announcing ${BalenaDevice.ip} as multi-room master!`,
		);
		FleetComms.publish('fleet-update', { master: BalenaDevice.ip });
	}
});

// Event: 'fleet-update'
// Origin: fleet
// If a new master server is announced update internal record and reset multiroom-client service
FleetComms.on('fleet-update', async (data: FleetUpdate) => {
	logEvent(`fleet-update ${JSON.stringify(data)}`);

	if (
		MultiRoom.isNewMaster(data.master) &&
		!MultiRoom.forced &&
		!MultiRoom.disallowUpdates
	) {
		logEvent(
			`Multi-room master has changed to ${data.master}, restarting snapcast-client...`,
		);
		MultiRoom.setMaster(data.master);
		BalenaService.restart(
			BalenaDevice.appId,
			constants.multiroom.clientServiceName,
		);
	}
});

// Event: 'fleet-heartbeat'
// Origin: fleet
// On each heartbeat force master to re-announce itself
FleetComms.onHeartbeat((data: FleetHeartbeat) => {
	logEvent(`fleet-heartbeat ${JSON.stringify(data)}`);

	if (MultiRoom.master === BalenaDevice.ip && data.origin !== BalenaDevice.ip) {
		logEvent(`Re-announcing self (${BalenaDevice.ip}) as multi-room master!`);
		FleetComms.publish('fleet-update', { master: MultiRoom.master });
	}
});
