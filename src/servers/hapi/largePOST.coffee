Hapi = require("hapi")

host = process.env.HOST || 'localhost'
port = process.env.PORT || 3000
CMinion = require("../../minion")
Minion = new CMinion()
server = new Hapi.Server(host, port, {payload: {maxBytes: 9999999999999999}})
hello = {
  method: "POST",
  path: "/",
  config: {
    query: {
      id: Hapi.Types.String()
    },
    handler: (req) ->
      req.reply(req.raw.req.headers["content-length"])
      Minion.logRequest(req.query)
  }
}

server.addRoute(hello)
Minion.started()
server.start()