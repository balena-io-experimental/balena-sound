import { getIPAddress } from './utils'
import { SoundModes } from "./types"
import { constants } from './constants'
import { startBalenaService, stopBalenaService, restartBalenaService } from './utils'
import BalenaAudio from './audio-block'

interface MultiRoomConfig {
  master: String,
  forced: boolean
}

interface DeviceConfig {
  ip: string,
  type: string
}

export default class SoundConfig {
  public mode: SoundModes = constants.mode
  public device: DeviceConfig = {
    ip: getIPAddress() ?? 'localhost',
    type: constants.balenaDeviceType
  }
  public multiroom: MultiRoomConfig = {
    master: constants.multiroom.master ?? this.device.ip,
    forced: constants.multiroom.forced
  }
  private audioBlock: BalenaAudio

  bindAudioBlock(audioBlock: BalenaAudio) {
    this.audioBlock = audioBlock
  }

  setMultiRoomMaster(master: string) {
    if (!this.multiroom.forced) {
      this.multiroom.master = master
      restartBalenaService('multiroom-client')
    }
  }

  // TODO: Fix bug - This won't work if there are USB or DAC sound cards because it currently relies on hardcoded sink|sinkInput indexes
  // sinkInput 0 usually refers to the "balena-sound.input to snapcast|balenaSound.output" loopback
  // sink 2 usually refers to "balenaSound.output" sink
  // sink 3 usually refers to "snapcast" sink
  // But this numbering gets altered if USB or DAC soundcards are found
  setMode(mode: SoundModes): boolean {
    let oldMode: SoundModes = this.mode
    let modeUpdated: boolean = mode !== oldMode

    if (mode && Object.values(SoundModes).includes(mode)) {
      this.mode = SoundModes[mode]

      if (modeUpdated) {
        switch (this.mode) {
          case SoundModes.MULTI_ROOM:
            // start
            startBalenaService('multiroom-server')
            startBalenaService('multiroom-client')
            startBalenaService('airplay')
            startBalenaService('spotify')
            startBalenaService('upnp')
            startBalenaService('bluetooth')

            this.audioBlock.moveSinkInput(0, 3)
            break
          case SoundModes.MULTI_ROOM_CLIENT:
            // stop
            stopBalenaService('multiroom-server')
            stopBalenaService('airplay')
            stopBalenaService('spotify')
            stopBalenaService('upnp')
            stopBalenaService('bluetooth')
            
            // start
            startBalenaService('multiroom-client')
            break
          case SoundModes.STANDALONE:
            // stop
            stopBalenaService('multiroom-server')
            stopBalenaService('multiroom-client')

            // start
            startBalenaService('airplay')
            startBalenaService('spotify')
            startBalenaService('upnp')
            startBalenaService('bluetooth')
            
            this.audioBlock.moveSinkInput(0, 2)
            break
          default:
            break
        }
      }
    } else {
      console.log(`Error setting mode, invalid mode: ${mode}`)
    }

    return modeUpdated
  }

  isMultiRoomEnabled(): boolean {
    let mrModes: SoundModes[] = [SoundModes.MULTI_ROOM, SoundModes.MULTI_ROOM_CLIENT]
    return mrModes.includes(this.mode)
  }

  isMultiRoomServer(): boolean {
    let mrModes: SoundModes[] = [SoundModes.MULTI_ROOM]
    return mrModes.includes(this.mode)
  }

  isMultiRoomMaster(): boolean {
    return this.isMultiRoomServer() && this.device.ip === this.multiroom.master
  }

  isNewMultiRoomMaster(master: string): boolean {
    return this.isMultiRoomEnabled() && this.multiroom.master !== master
  }

}