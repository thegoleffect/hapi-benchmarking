restify = require("restify")

server = restify.createServer()
server.use(restify.bodyParser())
server.post("/", (req, res) ->
  res.send(req.headers["content-length"])
)

port = process.env.PORT || 3000
server.listen(port, () ->
  console.log("Listening on port #{port}")
)