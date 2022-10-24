import { Router } from 'express';
import asyncHandler from 'express-async-handler';
import AudioBlock from '../audio-block';
import { BigIntParse } from '../utils/big-int';
import { checkInt } from '../utils/validation';

const router = Router();

router
	.route('/')
	.get(asyncHandler(async (_req, res) => res.json(await AudioBlock.getInfo())));

router
	.route('/volume')
	.get(
		asyncHandler(async (_req, res) => res.json(await AudioBlock.getVolume())),
	);

router.route('/volume').post(
	asyncHandler(async (req, res) => {
		const volume = checkInt(req.body.volume);
		if (volume === undefined) {
			throw new Error('Invalid volume');
		}

		return res.json(await AudioBlock.setVolume(volume));
	}),
);

router
	.route('/sinks')
	.get(
		asyncHandler(async (_req, res) =>
			res.json(BigIntParse(await AudioBlock.getSinkList())),
		),
	);

export default router;
