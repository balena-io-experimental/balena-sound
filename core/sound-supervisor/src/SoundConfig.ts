import { getIPAddress } from './utils'
import { SoundModes } from "./types"
import { constants } from './constants'

interface MultiRoomConfig {
  master: String,
  forced: boolean
}

interface DeviceConfig {
  ip: string,
  type: string
}

export default class SoundConfig {
  public mode: SoundModes
  public device: DeviceConfig = {
    ip: getIPAddress() ?? 'localhost',
    type: constants.balenaDeviceType
  }
  public multiroom: MultiRoomConfig = {
    master: constants.multiroom.master ?? this.device.ip,
    forced: constants.multiroom.forced
  }

  constructor() {
    this.setMode(<SoundModes>constants.mode)
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