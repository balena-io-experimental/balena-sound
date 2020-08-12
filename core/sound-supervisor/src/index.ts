import * as cote from 'cote'
import BalenaAudio from './audio-block'
import SoundAPI from './SoundAPI'
import SoundConfig from './SoundConfig'
import { restartBalenaService, getIPAddress } from './utils'
import { SoundModes } from './types'

// balenaSound core
const config: SoundConfig = new SoundConfig(process.env.SOUND_MODE)
const audioBlock: BalenaAudio = new BalenaAudio('tcp:localhost:4317')
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
  fleetPublisher.publish('fleet-sync', { type: 'sync', origin: getIPAddress() })
}

// Event: "play"
// On audio playback, set this server as the multiroom-master
audioBlock.on('play', () => {
  if (config.mode === SoundModes.MULTI_ROOM) {
    console.log(`Playback started, announcing ${config.device.ip} as multi-room master!`)
    fleetPublisher.publish('fleet-update', { type: 'master', master: config.device.ip })
  }
})

// Event: "fleet-update"
// If the master server changed, reset multiroom-client service
fleetSubscriber.on('fleet-update', async (data: any) => {
  if (config.mode === SoundModes.MULTI_ROOM && config.multiroom.master !== data.master) {
    console.log(`Multi-room master has changed to ${data.master}, restarting snapcast-client...`)
    await restartBalenaService('multiroom-client')
    config.multiroom.master = data.master
  }
})

// Event: "fleet-sync"
// Whenever a device joins the network, re-announce current master
fleetSubscriber.on('fleet-sync', (data: any) => {
  let ip: string | null = getIPAddress()
  if (config.mode === SoundModes.MULTI_ROOM && config.multiroom.master === ip && data.origin !== ip) {
    console.log(`New multi-room device joined, syncing fleet...`)
    fleetPublisher.publish('fleet-update', { type: 'master', master: config.multiroom.master })
  }
})
