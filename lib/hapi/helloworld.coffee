Hapi = require("hapi")

port = process.env.PORT || 3000
server = new Hapi.Server('localhost', port)
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