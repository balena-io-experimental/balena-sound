import * as os from 'os'
import axios, { AxiosResponse } from 'axios'

export function getIPAddresses(): string[] {
  let networkInterfaces: object = os.networkInterfaces()
  let addresses: string[] = Object.keys(networkInterfaces)
    .filter(i => i.includes('wlan') || i.includes('eth'))
    .map(i => networkInterfaces[i])
    .flat()
    .filter(i => !i.internal && i.family === 'IPv4')
    .map(i => i.address)

  return addresses
}

export function getIPAddress(): string | null {
  return getIPAddresses()[0] ?? null
}

export function restartBalenaService(service: string): Promise<AxiosResponse<any>> {
  return executeBalenaServiceAction(service, 'restart')

}

export function startBalenaService(service: string): Promise<AxiosResponse<any>> {
  return executeBalenaServiceAction(service, 'start')
}

export function stopBalenaService(service: string): Promise<AxiosResponse<any>> {
  return executeBalenaServiceAction(service, 'stop')
}

function executeBalenaServiceAction (service: string, action: string): Promise<AxiosResponse<any>> {
  try {
    let url: string = `${process.env.BALENA_SUPERVISOR_ADDRESS}/v2/applications/${process.env.BALENA_APP_ID}/${action}-service?apikey=${process.env.BALENA_SUPERVISOR_API_KEY}`
    return axios.post(url, { serviceName: service })
  } catch (error) {
    console.log(error.message)
    return Promise.reject(error.message)
  }
}

export function rebootDevice ():Promise<AxiosResponse<any>> {
  return axios.post(`${process.env.BALENA_SUPERVISOR_ADDRESS}/v1/reboot?apikey=${process.env.BALENA_SUPERVISOR_API_KEY}`)
}

export function shutdownDevice ():Promise<AxiosResponse<any>> {
  return axios.post(`${process.env.BALENA_SUPERVISOR_ADDRESS}/v1/shutdown?apikey=${process.env.BALENA_SUPERVISOR_API_KEY}`)
}

export function restartDevice ():Promise<AxiosResponse<any>> {
  return axios.post(`${process.env.BALENA_SUPERVISOR_ADDRESS}/v1/restart?apikey=${process.env.BALENA_SUPERVISOR_API_KEY}`, { appId: process.env.BALENA_APP_ID})
}