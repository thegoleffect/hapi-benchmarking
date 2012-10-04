dns = require("dns")
os = require("os")

Hapi = require("hapi")

host = process.env.HOST || 'localhost'
port = process.env.PORT || 3000
MAXROUTES = process.env.MAXROUTES || 100000
server = new Hapi.Server(host, port)

route = (p = "/") ->
  return {
    method: "GET",
    path: p,
    config: {
      handler: (req) ->
        req.reply("Hello World.")
    }
  }

for i in [0..MAXROUTES]
  r = "/#{i}"
  server.addRoute(route(r))
  # console.log('adding route ' + r)

server.start()