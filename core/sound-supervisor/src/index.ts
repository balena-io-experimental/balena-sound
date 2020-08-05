import * as os from 'os'
import * as express from 'express'
import { Application } from 'express'

interface SoundConfig {
  mode: string,
  master: string
}

let config: SoundConfig = {
  mode: process.env.SOUND_MODE ?? 'MULTI_ROOM',
  master: getIPAddress() ?? 'multiroom-server'
}

export default class SoundAPI {
  private api: Application

  constructor() {
    this.api = express()

    this.api.get('/ping', (_req, res) => res.send('OK'))

    for (const [key, value] of Object.entries(config)) {
      this.api.get(`/${key}`, (_req, res) => res.status(200).send(value))
    }

  }

  public async listen(port: number): Promise<void> {
    return new Promise((resolve) => {
      this.api.listen(port, () => {
        console.log(`Sound supervisor listening on http://localhost:${port}`)
        return resolve()
      })
    })
  }

}

let soundSupervisor: SoundAPI = new SoundAPI()
soundSupervisor.listen(3000)


function getIPAddress(): string | null {
  let networkInterfaces: object = os.networkInterfaces()
  let addresses: string[] = Object.keys(networkInterfaces)
    .filter(i => i.includes('wlan') || i.includes('eth'))
    .map(i => networkInterfaces[i])
    .flat()
    .filter(i => !i.internal && i.family === 'IPv4')
    .map(i => i.address)

  return addresses[0] ?? null
}