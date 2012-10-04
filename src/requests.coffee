request = require("request")

maxRequests = process.env.MAXREQUESTS || 10000

options = {
  method: "GET",
  uri: "http://localhost:3000/"
}

onComplete = (err, res, body) ->
  # do nothing

for n in [0..maxRequests]
  request(options, onComplete)

process.send({status: -1})