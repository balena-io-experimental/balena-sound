import * as path from 'path'
import * as express from 'express'
import { Application } from 'express'
import SoundConfig from './SoundConfig'
import BalenaAudio from './audio-block'
import { SoundModes } from './types'
import { startBalenaService, stopBalenaService } from './utils'
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

    // Change config
    // This won't work if there are USB or DAC sound cards because it currently relies on hardcoded sink|sinkInput indexes
    // sinkInput 0 usually refers to the "balena-sound.input to snapcast|balenaSound.output" loopback
    // sink 2 usually refers to "balenaSound.output" sink
    // sink 3 usually refers to "snapcast" sink
    this.api.post('/mode', (req, res) => {
      let oldMode: SoundModes = this.config.mode
      let newMode: SoundModes = this.config.setMode(req.body.mode)
      let updated: boolean = oldMode !== newMode

      if (updated) {
        switch (newMode) {
          case SoundModes.MULTI_ROOM:
            startBalenaService('multiroom-server')
            startBalenaService('multiroom-client')
            this.audioBlock.moveSinkInput(0, 3)
            break
          case SoundModes.MULTI_ROOM_CLIENT:
            stopBalenaService('multiroom-server')
            startBalenaService('multiroom-client')
            // TODO: stop plugin services, do same thing at startup
            break
          case SoundModes.STANDALONE:
            stopBalenaService('multiroom-server')
            stopBalenaService('multiroom-client')
            this.audioBlock.moveSinkInput(0, 2)
            break
          default:
            break
        }
      }
      res.json({ mode: newMode, updated })
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