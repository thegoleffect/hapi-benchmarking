restify = require("restify")

server = restify.createServer()
port = process.env.PORT || 3000
MAXROUTES = process.env.MAXROUTES || 100000

for i in [0..MAXROUTES]
  r = "/#{i}"
  server.get(r, (req, res) ->
    res.send("Hello World.")
  )

server.listen(port, () ->
  console.log("Listening on port #{port}")
)