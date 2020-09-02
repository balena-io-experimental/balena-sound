import * as path from 'path'
import * as express from 'express'
import { Application } from 'express'
import SoundConfig from './SoundConfig'
import BalenaAudio from './audio-block'
import * as asyncHandler from 'express-async-handler'
import { constants } from './constants'

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
      this.api.get(`/${key}`, (_req, res) => res.send(this.config[key]))
      if (typeof value === 'object') {
        for (const [subKey] of Object.entries(<any>value)) {
          this.api.get(`/${key}/${subKey}`, (_req, res) => res.send(this.config[key][subKey]))
        }
      }
    }

    // Change mode
    this.api.post('/mode', (req, res) => {
      let updated: boolean = this.config.setMode(req.body.mode)
      res.json({ mode: this.config.mode, updated })
    })

    // Audio block: use only for debugging/experimental, not ready for end user
    this.api.use('/secret', express.static(path.join(__dirname, 'ui')))
    this.api.get('/audio', asyncHandler(async (_req, res) => res.json(await this.audioBlock.getInfo())))
    this.api.get('/audio/volume', asyncHandler(async (_req, res) => res.json(await this.audioBlock.getVolume())))
    this.api.post('/audio/volume', asyncHandler(async (req, res) => res.json(await this.audioBlock.setVolume(req.body.volume))))
    this.api.get('/audio/sinks', asyncHandler(async (_req, res) => res.json(stringify(await this.audioBlock.getSinks()))))
    this.api.get('/support', asyncHandler(async (_req, res) => {
      res.json({
        config: this.config,
        audio: await this.audioBlock.getInfo(),
        sinks: stringify(await this.audioBlock.getSinks()),
        volume: await this.audioBlock.getVolume(),
        constants: constants
      })
    }))
    this.api.use((err: Error, _req, res, _next) => {
      res.status(500).json({ error: err.message })
    })
  }

  public async listen(port: number): Promise<void> {
    return new Promise((resolve) => {
      this.api.listen(port, () => {
        console.log(`Sound supervisor listening on port ${port}`)
        return resolve()
      })
    })
  }

}

// Required to avoid: "TypeError: Do not know how to serialize a BigInt"
function stringify(value) {
  return JSON.parse(JSON.stringify(value, (_, v) => typeof v === 'bigint' ? `${v}n` : v))
}