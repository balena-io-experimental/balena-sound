
import * as express from 'express'
import { Application } from 'express'
import SoundConfig from './SoundConfig'

export default class SoundAPI {
  private api: Application

  constructor(private config: SoundConfig) {
    this.api = express()

    // Healthcheck endpoint
    this.api.get('/ping', (_req, res) => res.send('OK'))

    // Expose all sound config variables
    for (const [key, value] of Object.entries(this.config)) {
      this.api.get(`/${key}`, (_req, res) => res.status(200).send(value))
      if (typeof value === 'object'){
        for (const [subKey, subValue] of Object.entries(<any>value)) {
          this.api.get(`/${key}/${subKey}`, (_req, res) => res.status(200).send(subValue))
        }
      }
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