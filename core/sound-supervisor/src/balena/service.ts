import BalenaSupervisorRequest from './supervisor-request';

class BalenaServiceAction extends BalenaSupervisorRequest {
	public data: { serviceName: string };

	constructor(appId: string, service: string, action: string) {
		super(`v2/applications/${appId}/${action}-service`);
		this.data = {
			serviceName: service,
		};
	}
}

export class BalenaService {
	static start = (appId: string, service: string) =>
		new BalenaServiceAction(appId, service, 'start').execute();
	static stop = (appId: string, service: string) =>
		new BalenaServiceAction(appId, service, 'stop').execute();
	static restart = (appId: string, service: string) =>
		new BalenaServiceAction(appId, service, 'restart').execute();
}
