let date = require('moment')().format('YYYYMMDD')
let commit = 'unknown'

try {
  commit = require('child_process').execSync('git rev-parse HEAD').toString().slice(0, 5)
} catch (error) {
  console.log('Git repository not found, using default commit hash')
  commit = 'build'
}

let version = `"${date}-${commit}"`

console.log(`current version is ${version}`)

module.exports = {
  NODE_ENV: '"development"',
  VERSION: version,
  USE_SENTRY: '0'
}
