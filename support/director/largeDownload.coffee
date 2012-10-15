http = require("http")
director = require("director")

download = () ->
  self = this
  
  fs.readFile(filepath, (err, data) ->
    throw err if err
    self.res.writeHead(200, {'Content-Type': 'text/plain'})
    process.send({status: 0}) if process.send
    self.res.send(data.toString())
  )

router = new director.http.Router({
  "/": {
    get: download
  }
})

server = http.createServer((req, res) ->
  router.dispatch(req, res, (err) ->
    if err
      res.writeHead(404)
      res.end()
  )
)

process.send({status: 0, increment: 0}) if process.send
port = process.env.PORT || 3000
server.listen(port)