express = require("express")
CMinion = require("../../src/minion")
Minion = new CMinion()

app = express()
app.use(express.bodyParser())
app.post("/", (req, res) ->
  res.send(req.headers["content-length"])
  Minion.logRequest()
)

port = process.env.PORT || 3000
Minion.started()
app.listen(port, () ->
  console.log("Listening on port #{port}")
)