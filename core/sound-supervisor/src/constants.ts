import { SoundModes } from "./types"

function checkInt(s: string | undefined): number | undefined {
  return s ? parseInt(s) : undefined
}

let deviceType: string = process.env.BALENA_DEVICE_TYPE ?? 'unknown'

export function defaultMode(): SoundModes {
  return ['raspberry-pi', 'raspberry-pi2', 'unknown'].includes(deviceType) ? SoundModes.STANDALONE : SoundModes.MULTI_ROOM
}

export const constants = {
  debug: process.env.SOUND_SUPERVISOR_DEBUG ? true : false,
  port: checkInt(process.env.SOUND_SUPERVISOR_PORT) ?? 3000,
  coteDelay: checkInt(process.env.SOUND_COTE_DELAY) ?? 5000,
  mode: (<SoundModes>process.env.SOUND_MODE) ?? defaultMode(),
  balenaDeviceType: deviceType,
  multiroom: {
    master: process.env.SOUND_MULTIROOM_MASTER,
    forced: process.env.SOUND_MULTIROOM_MASTER ? true : false
  },
  volume: checkInt(process.env.SOUND_VOLUME) ?? 75
}

