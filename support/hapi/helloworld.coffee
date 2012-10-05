dns = require("dns")
os = require("os")

Hapi = require("hapi")

host = process.env.HOST || 'localhost'
port = process.env.PORT || 3000

server = new Hapi.Server(host, port)
hello = {
  method: "GET",
  path: "/",
  config: {
    handler: (req) ->
      req.reply("Hello World.")
  }
}

server.addRoute(hello)
server.start()