os = require("os")
process.on('message', (msg) ->
  action = msg.action
  switch action
    when "mem"
      data = process.memoryUsage()
    when "load"
      data = os.loadavg()
    else
      data = {}
  
  process.send({action: action, data: data}) if action
)

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




# Hapi = require("hapi")

# host = process.env.HOST || 'localhost'
# port = process.env.PORT || 3000

# server = new Hapi.Server(host, port)
# hello = {
#   method: "GET",
#   path: "/",
#   config: {
#     handler: (req) ->
#       process.send({status: 0})
#       req.reply("Hello World.")
#   }
# }

# server.addRoute(hello)
# process.send({status: 0, increment: 0})
# server.start()