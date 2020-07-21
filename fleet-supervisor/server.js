const cote = require('cote')
const SnapcastServer = require('./src/SnapcastServer')
const MasterServer = require('./src/MasterServer')
const { getIPAddress, restartBalenaService } = require('./src/utils')

const snapcastServer = new SnapcastServer()
const masterServer = new MasterServer({ defaultAddress: getIPAddress() })
const fleetPublisher = new cote.Publisher({ name: 'Fleet publisher' })
const fleetSubscriber = new cote.Subscriber({ name: 'Fleet subscriber' })

// Connect to the local snapcast server
// On audio playback, set this server as the master
// Pi 1/2 family is not powerful enough to run snapcast-server, don't attempt to connect
// If Client Only mode is activated, don't attempt to connect
if ((process.env.BALENA_DEVICE_TYPE !== 'raspberry-pi' || process.env.BALENA_DEVICE_TYPE !== 'raspberry-pi2') && !process.env.CLIENT_ONLY_MULTI_ROOM) {
  snapcastServer.connect()
  snapcastServer.onPlayback((data) => {
    fleetPublisher.publish('fleet-update', { master: getIPAddress() })
  })
}

// Handle fleet-update events
// Whenever the master server changes, reset snapcast-client service
fleetSubscriber.on('fleet-update', (update) => {
  if (masterServer.hasChanged(update.master)) {
    console.log(`Multi-room master has changed to ${update.master}, restarting snapcast-client`)
    restartBalenaService('snapcast-client')
  }
  masterServer.update(update.master)
})

// Handle fleet-sync events
// Whenever a device joins the network, ask for current master
fleetSubscriber.on('fleet-sync', () => {
  if (masterServer.isCurrentMaster) {
    console.log(`New multi-room device joined, syncing fleet...`)
    fleetPublisher.publish('fleet-update', { master: getIPAddress() })
  }
})

// Allow cote to establish connections before sending fleet-sync
setTimeout(() => {
  fleetPublisher.publish('fleet-sync')
}, 3000)

// Simple http server to share server address
// On restart, snapcast-client service will grab the new master server ip address from here
// TODO: Find a better way of doing this?
masterServer.listen()
