import BalenaAudio from 'balena-audio';
import constants from './constants';
import log from './logger';

const AudioBlock = new BalenaAudio(constants.audioBlockAddress);
export default AudioBlock;

const logAudio = log.extend('audio');

export async function printAudioInfo() {
	const sinks = (await AudioBlock.getSinkList()).map(
		(s) => `[${s.index}] ${s.name}`,
	);
	logAudio('Audio sinks:');
	sinks.map((s) => logAudio(s));
}
export async function upgradeToMultiRoom() {
	const moduleList = await AudioBlock.getModuleList();
	const standaloneLoopback = moduleList.find(
		(m) =>
			m.argument.includes(`sink=${constants.pulseAudio.outputSink}`) &&
			m.argument.includes(`source=${constants.pulseAudio.inputSink}`),
	);
	const multiroomLoopback = moduleList.find(
		(m) =>
			m.argument.includes(`sink=${constants.pulseAudio.outputSink}`) &&
			m.argument.includes(`source=${constants.pulseAudio.multiroomSink}`),
	);

	if (standaloneLoopback !== undefined) {
		logAudio(
			`Unloading standalone loopback module - ${standaloneLoopback.name}:${standaloneLoopback.argument}.`,
		);
		await AudioBlock.unloadModule(standaloneLoopback.index);
	} else {
		logAudio(`Standalone loopback module already unloaded!`);
	}

	if (multiroomLoopback === undefined) {
		logAudio(
			`Loading multiroom loopback module - module-loopback:source=${constants.pulseAudio.multiroomSink}.monitor sink=${constants.pulseAudio.outputSink}.`,
		);
		await AudioBlock.loadModule(
			'module-loopback',
			`source=${constants.pulseAudio.multiroomSink}.monitor sink=${constants.pulseAudio.outputSink}`,
		);
	} else {
		logAudio(`Multiroom loopback module already loaded!`);
	}
}
