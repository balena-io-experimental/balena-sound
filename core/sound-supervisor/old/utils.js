const { execSync } = require('child_process')

module.exports.getIPAddress = () => {
  let address = '127.0.0.1'

  try {
    let command =`curl -s -X GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY"`
    let data = execSync(command)
    address = JSON.parse(data.toString()).ip_address.split(' ')[0]
  } catch (error) {
    console.log(error)
  }
  
  return address
}

module.exports.restartBalenaService = (serviceName) => {
  let command = `curl -s --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/restart-service?apikey=$BALENA_SUPERVISOR_API_KEY" -d \'{"serviceName": "${serviceName}"}\'`
  execSync(command)
}