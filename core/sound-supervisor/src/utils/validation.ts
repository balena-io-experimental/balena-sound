import _ from 'lodash';

export function checkInt(s: string | undefined): number | undefined {
	return s ? parseInt(s, 10) : undefined;
}

export function checkEnvVar(envVars: string | string[]) {
	if (typeof envVars === 'string') {
		envVars = [envVars];
	}

	for (const envVar of envVars) {
		if (process.env[envVar] === undefined) {
			throw new Error(`${envVar} enviroment variable is required!`);
		}
	}
	return true;
}

export function checkString(s: unknown): string | void {
	if (s == null || !_.isString(s) || _.includes(['null', 'undefined', ''], s)) {
		return;
	}

	return s;
}
