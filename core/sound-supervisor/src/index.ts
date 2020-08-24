import * as cote from 'cote'
import BalenaAudio from './audio-block'
import SoundAPI from './SoundAPI'
import SoundConfig from './SoundConfig'
import { restartBalenaService } from './utils'

// balenaSound core
const config: SoundConfig = new SoundConfig(process.env.SOUND_MODE ?? 'MULTI_ROOM')
const audioBlock: BalenaAudio = new BalenaAudio(`tcp:${config.device.ip}:4317`)
const soundAPI: SoundAPI = new SoundAPI(config, audioBlock)

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
  await soundAPI.listen(3000)
  await audioBlock.listen()

  // For multi room, allow cote to establish connections before sending fleet-sync
  if (config.isMultiRoomEnabled()) {
    setTimeout(() => {
      console.log('Joining the fleet, requesting master info with fleet-sync...')
      fleetPublisher.publish('fleet-sync', { type: 'sync', origin: config.device.ip })
    }, 3000)
  }
}

// Event: "play"
// On audio playback, set this server as the multiroom-master
// We check balena-sound.input as it's the sink that receives all audio sources
audioBlock.on('play', (sink: any) => {
  if (config.isMultiRoomServer() && sink.name === 'balena-sound.input') {
    console.log(`Playback started, announcing ${config.device.ip} as multi-room master!`)
    fleetPublisher.publish('fleet-update', { type: 'master', master: config.device.ip })
  }
})

// Event: "fleet-update"
// If the master server changed, reset multiroom-client service
fleetSubscriber.on('fleet-update', async (data: any) => {
  if (config.isNewMultiRoomMaster(data.master)) {
    console.log(`Multi-room master has changed to ${data.master}, restarting snapcast-client...`)
    config.setMultiRoomMaster(data.master)
    await restartBalenaService('multiroom-client')
  }
})

// Event: "fleet-sync"
// Whenever a device joins the network, re-announce current master
fleetSubscriber.on('fleet-sync', (data: any) => {
  if (config.isMultiRoomMaster() && data.origin !== config.device.ip) {
    console.log(`New multi-room device joined, syncing fleet...`)
    fleetPublisher.publish('fleet-update', { type: 'master', master: config.multiroom.master })
  }
})
