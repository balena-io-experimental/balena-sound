import { getIPAddress } from "./utils"
import { SoundModes } from "./types"

interface MultiRoomConfig {
  master: String,
  forced: boolean
}

interface DeviceConfig {
  ip: string,
  type: string
}

export default class SoundConfig {
  public mode: SoundModes = SoundModes.MULTI_ROOM
  public device: DeviceConfig = {
    ip: getIPAddress() ?? 'localhost',
    type: process.env.BALENA_DEVICE_TYPE ?? 'unknown'
  }
  public multiroom: MultiRoomConfig = {
    master: process.env.SOUND_MULTIROOM_MASTER ?? this.device.ip,
    forced: process.env.SOUND_MULTIROOM_MASTER ? true : false
  }

  constructor(mode: string) {
    this.setMode(<SoundModes>mode)
  }

  setMultiRoomMaster(master: string) {
    if (!this.multiroom.forced) {
      this.multiroom.master = master
    }
  }

  setMode(mode: SoundModes): SoundModes {
    if (mode && Object.values(SoundModes).includes(mode)) {
      this.mode = SoundModes[mode]
    } else {
      console.log(`Error setting mode, invalid mode: ${mode}`)
    }

    return this.mode
  }

  isMultiRoomEnabled(): boolean {
    let mrModes: SoundModes[] = [ SoundModes.MULTI_ROOM, SoundModes.MULTI_ROOM_CLIENT ]
    return mrModes.includes(this.mode)
  }

  isMultiRoomServer(): boolean {
    let mrModes: SoundModes[] = [ SoundModes.MULTI_ROOM ]
    return mrModes.includes(this.mode)
  }

  isMultiRoomMaster(): boolean {
    return this.isMultiRoomServer() && this.device.ip === this.multiroom.master
  }

  isNewMultiRoomMaster(master: string): boolean {
    return this.isMultiRoomEnabled() && this.multiroom.master !== master
  }

}