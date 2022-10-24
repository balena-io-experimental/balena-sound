import path from 'path';
import express from 'express';
import health from 'express-ping';
import { Application } from 'express';
import audioRoutes from './api/audio';
import deviceRoutes from './api/device';
import supportRoutes from './api/support';

const app: Application = express();
app.use(express.json());
app.use(health.ping());

app.use('/audio', audioRoutes);
app.use('/device', deviceRoutes);
app.use('/support', supportRoutes);
app.use('/', express.static(path.join(__dirname, 'ui')));

app.use(
	(
		err: Error,
		_req: express.Request,
		res: express.Response,
		_next: express.NextFunction,
	) => {
		res.status(500).json({ error: err.message });
	},
);

export default app;
