# express = require("express")

# app = express()

# app.get("/", (req, res) ->
#   process.send({status: 0})
#   res.send("Hello World.")
# )

# port = process.env.PORT || 3000
# app.listen(port, () ->
#   process.send({status: 0, increment: 0}) # initiate a start time
#   console.log("Listening on port #{port} at ", Date.now())
# )

process.on('message', (msg) ->
  switch msg.action
    when "mem"
      process.send({action: msg.action, data: process.memoryUsage()})
)


Hapi = require("hapi")

host = process.env.HOST || 'localhost'
port = process.env.PORT || 3000

server = new Hapi.Server(host, port)
hello = {
  method: "GET",
  path: "/",
  config: {
    handler: (req) ->
      process.send({status: 0})
      req.reply("Hello World.")
  }
}

server.addRoute(hello)
process.send({status: 0, increment: 0})
server.start()