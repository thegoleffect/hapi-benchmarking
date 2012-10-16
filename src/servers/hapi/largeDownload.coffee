fs = require("fs")
Hapi = require("hapi")

host = process.env.HOST || 'localhost'
port = process.env.PORT || 3000
CMinion = require("../../minion")
Minion = new CMinion()
filepath = "/usr/share/dict/words"
server = new Hapi.Server(host, port)

download = {
  method: "GET",
  path: "/",
  config: {
    handler: (req) ->
      fs.readFile(filepath, (err, data) ->
        throw err if err
        req.reply(data.toString())
        Minion.logRequest()
      )
      
  }
}

server.addRoute(download)
Minion.started()
server.start()


