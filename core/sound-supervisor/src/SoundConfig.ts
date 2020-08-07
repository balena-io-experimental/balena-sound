import { getIPAddress } from "./utils"
import { MultiRoomBlacklist, SoundModes } from "./types"

interface MultiRoomConfig {
  master: String,
  disabled: boolean
}

interface DeviceConfig {
  ip: string
}

export default class SoundConfig {
  public mode: string = 'MULTI_ROOM'
  public device: DeviceConfig = {
    ip: getIPAddress() ?? 'multiroom-server'
  }
  public multiroom: MultiRoomConfig = { master: this.device.ip, disabled: false}

  constructor(deviceType: string = '', mode: string = '') {
    if (Object.values(MultiRoomBlacklist).includes(deviceType)) {
      this.multiroom.disabled = true
    }
    if (Object.values(SoundModes).includes(mode)) {
      this.mode = SoundModes[mode]
    }
  }

}