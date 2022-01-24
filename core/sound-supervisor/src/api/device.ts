import { Router } from 'express';
import asyncHandler from 'express-async-handler';
import BalenaDevice from '../balena/device';
import MultiRoom from '../multi-room';
import { getSdk } from 'balena-sdk';
import { checkString } from '../utils/validation';

const sdk = getSdk({ apiUrl: 'https://api.balena-cloud.com/' });
sdk.auth.logout();
sdk.auth.loginWithToken(process.env.BALENA_API_KEY!); // Asserted by io.balena.features.balena-api: '1'

const router = Router();

router
	.route('/restart')
	.post(
		asyncHandler(async (_req, res) => res.json(await BalenaDevice.restart())),
	);

router
	.route('/reboot')
	.post(
		asyncHandler(async (_req, res) => res.json(await BalenaDevice.reboot())),
	);

router
	.route('/shutdown')
	.post(
		asyncHandler(async (_req, res) => res.json(await BalenaDevice.shutdown())),
	);

router.route('/dtoverlay').post(
	asyncHandler(async (req, res) => {
		const dtoverlay = checkString(req.body.dtoverlay);
		if (dtoverlay === undefined) {
			throw new Error('Invalid dtoverlay');
		}

		console.log(`Applying BALENA_HOST_CONFIG_dtoverlay=${dtoverlay}...`);
		await sdk.models.device.configVar.set(
			process.env.BALENA_DEVICE_UUID!,
			'BALENA_HOST_CONFIG_dtoverlay',
			dtoverlay,
		); // BALENA_DEVICE_UUID is always defined in balenaOS

		res.json({ status: 'OK' });
	}),
);

router.route('/multiroom').get((_req, res) => res.send(MultiRoom.master));

export default router;
