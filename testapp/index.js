'use strict'

const http = require('http')

const server = http.createServer()

server
  .on('request', (req, resp) => {
    resp.end(
      'This is a test app for https testing.'
    )
  })
  .listen(9000, '0.0.0.0', () => {
    console.log('HTTP server listening on port 9000')
  })
