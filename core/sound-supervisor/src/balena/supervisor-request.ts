import axios, { AxiosResponse } from 'axios';

export default class BalenaSupervisorRequest {
	public url: string;

	constructor(endpoint: string, public data?: any) {
		const { BALENA_SUPERVISOR_ADDRESS, BALENA_SUPERVISOR_API_KEY } =
			process.env;

		if (
			BALENA_SUPERVISOR_ADDRESS === undefined ||
			BALENA_SUPERVISOR_API_KEY === undefined
		) {
			throw new Error(
				'BALENA_SUPERVISOR_ADDRESS and BALENA_SUPERVISOR_API_KEY enviroment variables are required!',
			);
		}

		this.url = `${BALENA_SUPERVISOR_ADDRESS}/${endpoint.replace(
			/^\//,
			'',
		)}?apikey=${BALENA_SUPERVISOR_API_KEY}`;
	}

	execute(): Promise<AxiosResponse<any>> {
		return this.data ? axios.post(this.url, this.data) : axios.post(this.url);
	}
}
