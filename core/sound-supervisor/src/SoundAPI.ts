import * as path  from 'path'
import * as express from 'express'
import { Application } from 'express'
import SoundConfig from './SoundConfig'
import BalenaAudio from './audio-block'

export default class SoundAPI {
  private api: Application

  constructor(public config: SoundConfig, public audioBlock: BalenaAudio) {
    this.api = express()
    this.api.use(express.json())
    
    // Healthcheck endpoint
    this.api.get('/ping', (_req, res) => res.send('OK'))

    // All config
    this.api.get('/config', (_req, res) => res.json(this.config))

    // Expose all sound config variables
    for (const [key, value] of Object.entries(this.config)) {
      this.api.get(`/${key}`, (_req, res) => res.send(value))
      if (typeof value === 'object') {
        for (const [subKey, subValue] of Object.entries(<any>value)) {
          this.api.get(`/${key}/${subKey}`, (_req, res) => res.send(subValue))
        }
      }
    }

    // Audio block: use only for debugging, not ready for end user
    this.api.use('/secret', express.static(path.join(__dirname, 'ui')))
    this.api.get('/audio', async (_req, res) => res.json(await this.audioBlock.getServerInfo()))
    this.api.get('/audio/volume', async (_req, res) => res.json(await this.audioBlock.getVolume()))
    this.api.post('/audio/volume', async (req, res) => res.json(await this.audioBlock.setVolume(req.body.volume)))
    this.api.get('/audio/sinks', async (_req, res) => res.json(stringify(await this.audioBlock.getSinks())))

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

// Required to avoid: "TypeError: Do not know how to serialize a BigInt"
function stringify(value) {
  return JSON.parse(JSON.stringify(value, (_, v) => typeof v === 'bigint' ? `${v}n` : v))
}