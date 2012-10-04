express = require("express")
fs = require("fs")
filepath = "/usr/share/dict/words"

app = express()
app.get("/", (req, res) ->
  fs.readFile(filepath, (err, data) ->
    throw err if err
    res.send(data.toString())
  )
)

port = process.env.PORT || 3000
app.listen(port, () ->
  console.log("Listening on port #{port}")
)