express = require("express")

app = express()
port = process.env.PORT || 3000
MAXROUTES = process.env.MAXROUTES || 100000

for i in [0..MAXROUTES]
  r = "/#{i}"
  app.get(r, (req, res) -> res.send("Hello World."))

app.listen(port, () ->
  console.log("Listening on port #{port}")
)