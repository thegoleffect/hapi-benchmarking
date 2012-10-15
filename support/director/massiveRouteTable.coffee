http = require("http")
director = require("director")

helloWorld = () ->
  this.res.writeHead(200, {'Content-Type': 'text/plain'})
  process.send({status: 0}) if process.send
  this.res.end("Hello World.")

router = new director.http.Router()

server = http.createServer((req, res) ->
  router.dispatch(req, res, (err) ->
    if err
      res.writeHead(404)
      res.end()
  )
)

MAXROUTES = process.env.MAXROUTES || 100000

for i in [0..MAXROUTES]
  r = "/#{i}"
  router.get(r, helloWorld)



process.send({status: 0, increment: 0}) if process.send
port = process.env.PORT || 3000
server.listen(port)