fs = require("fs")
Hapi = require("hapi")

port = process.env.PORT || 3000
filepath = "/usr/share/dict/words"
server = new Hapi.Server('localhost', port)

download = {
  method: "GET",
  path: "/",
  config: {
    handler: (req) ->
      fs.readFile(filepath, (err, data) ->
        throw err if err
        req.reply(data.toString())
      )
      
  }
}

server.addRoute(download)
server.start()


