import * as path from 'path'
import * as express from 'express'
import { Application } from 'express'
import SoundConfig from './SoundConfig'
import BalenaAudio from './audio-block'
import * as asyncHandler from 'express-async-handler'
import { constants } from './constants'
import { restartDevice, rebootDevice, shutdownDevice } from './utils'
import { getSdk, BalenaSDK } from 'balena-sdk'

export default class SoundAPI {
  private api: Application
  private sdk: BalenaSDK

  constructor(public config: SoundConfig, public audioBlock: BalenaAudio) {
    this.sdk = getSdk({ apiUrl: 'https://api.balena-cloud.com/' })
    this.sdk.auth.logout()
    this.sdk.auth.loginWithToken(process.env.BALENA_API_KEY!) // Asserted by io.balena.features.balena-api: '1'
    
    this.api = express()
    this.api.use(express.json())

    // Healthcheck endpoint
    this.api.get('/ping', (_req, res) => res.send('OK'))

    // Configuration
    this.api.get('/config', (_req, res) => res.json(this.config))

    // Config variables -- one by one
    for (const [key, value] of Object.entries(this.config)) {
      this.api.get(`/${key}`, (_req, res) => res.send(this.config[key]))
      if (typeof value === 'object') {
        for (const [subKey] of Object.entries(<any>value)) {
          this.api.get(`/${key}/${subKey}`, (_req, res) => res.send(this.config[key][subKey]))
        }
      }
    }

    // Config variables -- update mode
    this.api.post('/mode', (req, res) => {
      let updated: boolean = this.config.setMode(req.body.mode)
      res.json({ mode: this.config.mode, updated })
    })

    // Audio block
    this.api.get('/audio', asyncHandler(async (_req, res) => res.json(await this.audioBlock.getInfo())))
    this.api.get('/audio/volume', asyncHandler(async (_req, res) => res.json(await this.audioBlock.getVolume())))
    this.api.post('/audio/volume', asyncHandler(async (req, res) => res.json(await this.audioBlock.setVolume(req.body.volume))))
    this.api.get('/audio/sinks', asyncHandler(async (_req, res) => res.json(stringify(await this.audioBlock.getSinks()))))

    // Device management
    this.api.post('/device/restart', asyncHandler(async (_req, res) => res.json(await restartDevice())))
    this.api.post('/device/reboot', asyncHandler(async (_req, res) => res.json(await rebootDevice())))
    this.api.post('/device/shutdown', asyncHandler(async (_req, res) => res.json(await shutdownDevice())))
    this.api.post('/device/dtoverlay', asyncHandler(async (req, res) => {
      const { dtoverlay } = req.body
      try {
        await this.sdk.models.device.configVar.set(process.env.BALENA_DEVICE_UUID!, 'BALENA_HOST_CONFIG_dtoverlay', dtoverlay) // BALENA_DEVICE_UUID is always present in balenaOS
        res.json({ status: 'OK' })
      } catch (error) {
        console.log(error)
        res.json({ error: error })
      }
    }))

    // Support endpoint -- Gathers information for troubleshooting
    this.api.get('/support', asyncHandler(async (_req, res) => {
      res.json({
        config: this.config,
        audio: await this.audioBlock.getInfo(),
        sinks: stringify(await this.audioBlock.getSinks()),
        volume: await this.audioBlock.getVolume(),
        constants: constants
      })
    }))

    // Local UI
    this.api.use('/', express.static(path.join(__dirname, 'ui')))

    // Error catchall
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