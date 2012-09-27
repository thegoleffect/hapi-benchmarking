express = require("express")

app = express()
app.use(express.bodyParser())
app.post("/", (req, res) ->
  res.send(req.headers["content-length"])
)

port = process.env.PORT || 3000
app.listen(port, () ->
  console.log("Listening on port #{port}")
)