import { checkInt } from './utils/validation';
import BalenaDevice from './balena/device';

export default {
	debug: process.env.DEBUG,
	port: checkInt(process.env.SOUND_SUPERVISOR_PORT) ?? 80,
	multiroom: {
		master: process.env.SOUND_MULTIROOM_MASTER,
		forced: process.env.SOUND_MULTIROOM_MASTER ? true : false,
		pollInterval:
			(checkInt(process.env.SOUND_MULTIROOM_POLL_INTERVAL) ?? 60) * 1000,
		disallowUpdates: process.env.SOUND_MULTIROOM_DISALLOW_UPDATES
			? true
			: false,
		clientServiceName:
			process.env.SOUND_MULTIROOM_CLIENT_SERVICE_NAME ?? 'multiroom-client',
	},
	initVolume: checkInt(process.env.SOUND_VOLUME) ?? 75,
	pulseAudio: {
		inputSink: process.env.SOUND_INPUT_SINK ?? 'balena-sound.input',
		outputSink: process.env.SOUND_OUTPUT_SINK ?? 'balena-sound.output',
		multiroomSink: process.env.SOUND_MULTIROOM_SINK ?? 'multi-room.input',
	},
	audioBlockAddress:
		process.env.SOUND_AUDIO_BLOCK ?? `tcp:${BalenaDevice.ip}:4317`,
};
