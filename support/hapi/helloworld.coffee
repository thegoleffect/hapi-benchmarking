dns = require("dns")
os = require("os")

Hapi = require("hapi")
Minion = new require("../src/minion")()

host = process.env.HOST || 'localhost'
port = process.env.PORT || 3000

server = new Hapi.Server(host, port)
hello = {
  method: "GET",
  path: "/",
  config: {
    handler: (req) ->
      req.reply("Hello World.")
      process.send({action: "request"})
  }
}

server.addRoute(hello)
process.send({action: "start"})
server.start()