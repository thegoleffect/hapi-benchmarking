http = require("http")
director = require("director")
CMinion = require("../../minion")
Minion = new CMinion()

helloWorld = () ->
  this.res.writeHead(200, {'Content-Type': 'text/plain'})
  this.res.end("Hello World.")
  Minion.logRequest(this.req, true)

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


Minion.started()
port = process.env.PORT || 3000
server.listen(port)