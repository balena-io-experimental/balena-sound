import * as cote from 'cote'
import BalenaAudio from './audio-block'
import SoundAPI from './SoundAPI'
import SoundConfig from './SoundConfig'
import { constants } from './constants'
import { resolve } from 'path'

// balenaSound core
const config: SoundConfig = new SoundConfig()
const audioBlock: BalenaAudio = new BalenaAudio(`tcp:${config.device.ip}:4317`)
const soundAPI: SoundAPI = new SoundAPI(config, audioBlock)
config.bindAudioBlock(audioBlock)

// Fleet communication
let discoveryOptions: any = {
  log: false,
  helloLogsEnabled: false,
  statusLogsEnabled: false
}
const fleetPublisher: cote.Publisher = new cote.Publisher({ name: 'balenaSound publisher' }, discoveryOptions)
const fleetSubscriber: cote.Subscriber = new cote.Subscriber({ name: 'balenaSound subscriber' }, discoveryOptions)

init()
async function init() {
  await soundAPI.listen(constants.port)
  await audioBlock.listen()
  await audioBlock.setVolume(constants.volume)

  // For multi room, allow cote to establish connections before sending fleet-sync
  if (config.isMultiRoomEnabled()) {
    await timeout(constants.coteDelay)
    console.log('Joining the fleet, requesting master info with fleet-sync...')
    fleetPublisher.publish('fleet-sync', { type: 'sync', origin: config.device.ip })
  }

  // Periodically sync the fleet
  setInterval(() => {
    if (config.isMultiRoomEnabled()) {
      fleetPublisher.publish('fleet-sync', { type: 'sync', origin: config.device.ip })
    }
  }, constants.multiroom.pollInterval)
}

// Event: "play"
// Source: audio block
// On audio playback, set this server as the multiroom-master
// We check balena-sound.input as it's the sink that receives all audio sources
audioBlock.on('play', (sink: any) => {
  if (constants.debug) {
    console.log(`[event] Audio block: play`)
    console.log(sink)
  }

  if (config.isMultiRoomServer() && sink.name === 'balena-sound.input') {
    console.log(`Playback started, announcing ${config.device.ip} as multi-room master!`)
    fleetPublisher.publish('fleet-update', { type: 'master', master: config.device.ip })
  }
})

// Event: "fleet-update"
// Source: fleet
// If the master server changed, reset multiroom-client service
fleetSubscriber.on('fleet-update', async (data: any) => {
  if (constants.debug) {
    console.log(`[event] fleet: fleet-update`)
    console.log(data)
  }

  if (config.isNewMultiRoomMaster(data.master)) {
    console.log(`Multi-room master has changed to ${data.master}, restarting snapcast-client...`)
    config.setMultiRoomMaster(data.master)
  }
})

// Event: "fleet-sync"
// Source: fleet
// When it receives this event the multiroom master announces itself as the master
// This happens when a new device joines the fleet but also periodically
fleetSubscriber.on('fleet-sync', (data: any) => {
  if (constants.debug) {
    console.log(`[event] fleet: fleet-sync`)
    console.log(data)
  }

  if (config.isMultiRoomMaster() && data.origin !== config.device.ip) {
    fleetPublisher.publish('fleet-update', { type: 'master', master: config.multiroom.master })
  }
})

async function timeout (delay: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, delay))
}