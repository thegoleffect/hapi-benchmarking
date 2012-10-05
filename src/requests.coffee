request = require("request")

maxRequests = process.env.MAXREQUESTS || 20000
concurrentRequests = process.CONCREQUESTS || 100

options = {
  method: "GET",
  uri: "http://localhost:3000/"
}

onComplete = (err, res, body) ->
  throw err if err
  # do nothing

n = 0
while n <= maxRequests 
  for k in [0..concurrentRequests]
    console.log(n)
    n++
    request(options, onComplete)

process.send({status: -1}) if process.send

# for n in [0..maxRequests]
#   console.log(n)
#   request(options, onComplete)

# process.send({status: -1})