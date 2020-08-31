function checkInt(s: string | undefined) : number | undefined {
  return s ? parseInt(s) : undefined
}

export const constants = {
  debug: process.env.SOUND_SUPERVISOR_DEBUG ? true : false,
  port: checkInt(process.env.SOUND_SUPERVISOR_PORT) ?? 3000,
  coteDelay: checkInt(process.env.SOUND_COTE_DELAY) ?? 5000,
  mode: process.env.SOUND_MODE ?? 'MULTI_ROOM',
  balenaDeviceType: process.env.BALENA_DEVICE_TYPE ?? 'unknown',
  multiroom: {
    master: process.env.SOUND_MULTIROOM_MASTER,
    forced: process.env.SOUND_MULTIROOM_MASTER ? true : false
  },
  volume: checkInt(process.env.SOUND_VOLUME) ?? 75
}

