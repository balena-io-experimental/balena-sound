import { getIPAddress } from "./utils"
import { SoundModes } from "./types"

interface MultiRoomConfig {
  master: String
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
  public multiroom: MultiRoomConfig = { master: this.device.ip }

  constructor(_mode: string | undefined) {
    if (_mode && Object.values(SoundModes).includes(<SoundModes>_mode)) {
      this.mode = SoundModes[_mode]
    }
  }

}