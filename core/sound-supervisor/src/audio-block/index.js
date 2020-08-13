"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const pulseaudio_1 = require("@tmigone/pulseaudio");
const ts_retry_promise_1 = require("ts-retry-promise");
class BalenaAudio extends pulseaudio_1.default {
    constructor(address = 'tcp:audio:4317', subToEvents = true, name = 'BalenaAudio') {
        super(address);
        this.address = address;
        this.subToEvents = subToEvents;
        this.name = name;
    }
    listen() {
        return __awaiter(this, void 0, void 0, function* () {
            const protocol = yield this.connectWithRetry();
            const client = yield this.setClientName(this.name);
            const server = yield this.getServerInfo();
            this.defaultSink = server.defaultSink;
            if (this.subToEvents) {
                yield this.subscribe();
                this.on('sink', (data) => __awaiter(this, void 0, void 0, function* () {
                    let sink = yield this.getSink(data.index);
                    switch (sink.state) {
                        case 0:
                            this.emit('play', sink);
                            break;
                        case 1:
                            this.emit('stop', sink);
                            break;
                        case 2:
                        default:
                            break;
                    }
                }));
            }
            return { client, protocol, server };
        });
    }
    connectWithRetry() {
        return __awaiter(this, void 0, void 0, function* () {
            return yield ts_retry_promise_1.retry(() => __awaiter(this, void 0, void 0, function* () {
                return yield this.connect();
            }), { retries: 'INFINITELY', delay: 5000, backoff: 'LINEAR', logger: (msg) => { console.log(`Error connecting to audio block - ${msg}`); } });
        });
    }
    setVolume(volume, sink) {
        return __awaiter(this, void 0, void 0, function* () {
            let sinkObject = yield this.getSink(sink !== null && sink !== void 0 ? sink : this.defaultSink);
            let level = Math.round(Math.max(0, Math.min(volume, 100)) / 100 * sinkObject.baseVolume);
            return yield this.setSinkVolume(sinkObject.index, level);
        });
    }
    getVolume(sink) {
        return __awaiter(this, void 0, void 0, function* () {
            let sinkObject = yield this.getSink(sink !== null && sink !== void 0 ? sink : this.defaultSink);
            return Math.round(sinkObject.channelVolumes.volumes[0] / sinkObject.baseVolume * 100);
        });
    }
}
exports.default = BalenaAudio;
//# sourceMappingURL=index.js.map