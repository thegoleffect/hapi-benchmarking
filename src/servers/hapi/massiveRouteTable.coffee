dns = require("dns")
os = require("os")

Hapi = require("hapi")

host = process.env.HOST || 'localhost'
port = process.env.PORT || 3000
CMinion = require("../../minion")
Minion = new CMinion()
MAXROUTES = process.env.MAXROUTES || 100000
server = new Hapi.Server(host, port)

route = (p = "/") ->
  return {
    method: "GET",
    path: p,
    config: {
      query: {
        id: Hapi.Types.String()
      },
      handler: (req) ->
        req.reply("Hello World.")
        Minion.logRequest(req.query)
    }
  }

for i in [0..MAXROUTES]
  r = "/#{i}"
  server.addRoute(route(r))
  # console.log('adding route ' + r)


Minion.started()
server.start()