restify = require("restify")
CMinion = require("../../src/minion")
Minion = new CMinion()

server = restify.createServer()
server.get("/", (req, res) ->
  res.send("Hello World.")
  Minion.logRequest()
)

port = process.env.PORT || 3000
Minion.started()
server.listen(port, () ->
  console.log("Listening on port #{port}")
)