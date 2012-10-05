express = require("express")

app = express()

app.get("/", (req, res) ->
  process.send({status: 0})
  res.send("Hello World.")
)

port = process.env.PORT || 3000
app.listen(port, () ->
  process.send({status: 0, increment: 0}) # initiate a start time
  console.log("Listening on port #{port} at ", Date.now())
)