import debug from 'debug';
import constants from './constants';

const logger = debug('main');
const logs = ['main', 'main:audio'];

if (constants.debug !== undefined) {
	logs.push('main:event');
}
debug.enable(logs.join(','));

export default logger;
