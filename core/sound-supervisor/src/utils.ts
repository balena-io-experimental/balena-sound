import * as os from 'os'
import axios, { AxiosResponse } from 'axios'

export function getIPAddress(): string | null {
  let networkInterfaces: object = os.networkInterfaces()
  let addresses: string[] = Object.keys(networkInterfaces)
    .filter(i => i.includes('wlan') || i.includes('eth'))
    .map(i => networkInterfaces[i])
    .flat()
    .filter(i => !i.internal && i.family === 'IPv4')
    .map(i => i.address)

  return addresses[0] ?? null
}

export function restartBalenaService(service: string): Promise<AxiosResponse<any>> {
  let url: string = `${process.env.BALENA_SUPERVISOR_ADDRESS}/v2/applications/${process.env.BALENA_APP_ID}/restart-service?apikey=${process.env.BALENA_SUPERVISOR_API_KEY}`
  return axios.post(url, { serviceName: service })
}

export function startBalenaService(service: string): Promise<AxiosResponse<any>> {
  let url: string = `${process.env.BALENA_SUPERVISOR_ADDRESS}/v2/applications/${process.env.BALENA_APP_ID}/start-service?apikey=${process.env.BALENA_SUPERVISOR_API_KEY}`
  return axios.post(url, { serviceName: service })
}

export function stopBalenaService(service: string): Promise<AxiosResponse<any>> {
  let url: string = `${process.env.BALENA_SUPERVISOR_ADDRESS}/v2/applications/${process.env.BALENA_APP_ID}/stop-service?apikey=${process.env.BALENA_SUPERVISOR_API_KEY}`
  return axios.post(url, { serviceName: service })
}