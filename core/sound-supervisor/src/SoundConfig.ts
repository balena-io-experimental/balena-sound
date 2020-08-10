import { getIPAddress } from "./utils"
import { MultiRoomBlacklist, SoundModes } from "./types"

interface MultiRoomConfig {
  master: String,
  disabled: boolean
}

interface DeviceConfig {
  ip: string,
  type: string
}

export default class SoundConfig {
  public mode: SoundModes = SoundModes.MULTI_ROOM
  public device: DeviceConfig = {
    ip: getIPAddress() ?? 'multiroom-server',
    type: process.env.BALENA_DEVICE_TYPE || 'unknown'
  }
  public multiroom: MultiRoomConfig = { master: this.device.ip, disabled: false }

  constructor(_mode: string | undefined) {
    if (Object.values(MultiRoomBlacklist).includes(this.device.type)) {
      this.multiroom.disabled = true
    }
    if (_mode && Object.values(SoundModes).includes(<SoundModes>_mode)) {
      this.mode = SoundModes[_mode]
    }
  }

}