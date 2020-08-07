import * as cote from 'cote'
import BalenaAudio from './audio-block'
import SoundAPI from './SoundAPI'
import SoundConfig from './SoundConfig'

// balenaSound core
const config: SoundConfig = new SoundConfig(process.env.BALENA_DEVICE_TYPE, process.env.SOUND_MODE)
const soundAPI: SoundAPI = new SoundAPI(config)
const audioBlock: BalenaAudio = new BalenaAudio('tcp:localhost:4317', '/run/pulse/pulseaudio.cookie')

// Fleet communication
const fleetPublisher: cote.Publisher = new cote.Publisher({ name: 'balenaSound publisher' })
// const fleetSubscriber: cote.Subscriber = new cote.Subscriber({ name: 'balenaSound subscriber' })

async function run () {
  await soundAPI.listen(3000)
  console.log('hola');
  
  await audioBlock.listen()
  console.log('chau');
  
  audioBlock.on('play', () => {
    console.log(`Playback started, announcing ${config.device.ip} as new master!`)
    fleetPublisher.publish('fleet-update', { type: 'master', master: config.device.ip })
  })
}

run()