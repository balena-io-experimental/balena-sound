import * as path from 'path'
import * as express from 'express'
import { Application } from 'express'
import SoundConfig from './SoundConfig'
import BalenaAudio from './audio-block'
import { SoundModes } from './types'
import { startBalenaService, stopBalenaService } from './utils'

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

    // Change config
    // This might not always work because it currently relies on hardcoded sink|sinkInput indexes
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

    // Audio block: use only for debugging, not ready for end user
    this.api.use('/secret', express.static(path.join(__dirname, 'ui')))
    this.api.get('/audio', async (_req, res) => {
      try {
        res.json(await this.audioBlock.getServerInfo())
      } catch (error) {
        res.status(500).json({ error: 'Could not reach audioblock' })
      }
    })
    this.api.get('/audio/volume', async (_req, res) => res.json(await this.audioBlock.getVolume()))
    this.api.post('/audio/volume', async (req, res) => res.json(await this.audioBlock.setVolume(req.body.volume)))
    this.api.get('/audio/sinks', async (_req, res) => res.json(stringify(await this.audioBlock.getSinks())))

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