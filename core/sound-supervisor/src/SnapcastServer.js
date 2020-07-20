const net = require('net')

class SnapcastServer {
  constructor (config = {}) {
    const options = Object.assign({
      port: 1705,
      hostname: 'localhost'
    }, config)

    this.options = options
    this.socket = new net.Socket()
  }

  connect () {
    this.socket.connect(this.options.port, this.options.hostname)
  }

  onPlayback (callback) {
    this.socket.on('data', (data) => { 
      if (this.getAction(data) === 'playing') {
        callback()
      }
    })
  }

  getAction (data) {
    try {
      let json = JSON.parse(data)
      return json.params.stream.status
    } catch (error) {
      return ''
    }
  }
}

module.exports = SnapcastServer