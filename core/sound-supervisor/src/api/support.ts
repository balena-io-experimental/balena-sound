import fs from 'fs';
import { Router } from 'express';
import asyncHandler from 'express-async-handler';
import AudioBlock from '../audio-block';
import { BigIntParse } from '../utils/big-int';
import constants from '../constants';
import BalenaDevice from '../balena/device';
import MultiRoom from '../multi-room';

const version = {
	version: fs.readFileSync('VERSION', 'utf-8'),
};
const audio = async () => {
	return {
		info: await AudioBlock.getInfo(),
		sinks: BigIntParse(await AudioBlock.getSinkList()),
		volume: await AudioBlock.getVolume(),
	};
};

const device = {
	ip: BalenaDevice.ip,
	type: BalenaDevice.type,
	appId: BalenaDevice.appId,
	isMultiRoomCapable: BalenaDevice.isMultiRoomCapable,
};

const multiroom = {
	master: MultiRoom.master,
	forced: MultiRoom.forced,
	disallowUpdates: MultiRoom.disallowUpdates,
};

const router = Router();

router.route('/').get(
	asyncHandler(async (_req, res) => {
		res.json({
			version,
			audio: await audio(),
			constants,
			device,
			multiroom,
		});
	}),
);

router.route('/version').get((_req, res) => res.json(version));

router
	.route('/audio')
	.get(asyncHandler(async (_req, res) => res.json(await audio())));

router
	.route('/constants')
	.get(asyncHandler(async (_req, res) => res.json(constants)));

router
	.route('/device')
	.get(asyncHandler(async (_req, res) => res.json(device)));

router
	.route('/multiroom')
	.get(asyncHandler(async (_req, res) => res.json(multiroom)));

export default router;
