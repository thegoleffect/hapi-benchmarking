Hapi = require("hapi")

host = process.env.HOST || 'localhost'
port = process.env.PORT || 3000
server = new Hapi.Server(host, port, {payload: {maxBytes: 9999999999999999}})
hello = {
  method: "POST",
  path: "/",
  config: {
    handler: (req) ->
      req.reply(req.raw.req.headers["content-length"])
  }
}

server.addRoute(hello)
server.start()