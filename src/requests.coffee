_ = require("underscore")
async = require("async")
http = require("http")
request = require("request")

maxRequests = +process.env.MAXREQUESTS || 1000
concurrentRequests = +process.env.CONCREQUESTS || 50
requestPath = process.env.REQUESTPATH || "/"
uri = process.env.HOST || "localhost:3000"

http.Agent.defaultMaxSockets = concurrentRequests
http.globalAgent.maxSockets = concurrentRequests

baseOptions = {
  host: process.env.HOST,
  port: 80
}

requestOptions = {
  method: "GET",
  path: requestPath
}


requestsCount = 0
responseCount = 0

options = _.extend({}, baseOptions, requestOptions)

request = (i, callback) ->
  requestsCount++
  r = http.request(options, (res) ->
    res.on("end", () ->
      responseCount++
      callback() if callback and typeof callback == "function"
    )
  )
  r.end()

printCounts = () ->
  console.log(requestsCount, responseCount, maxRequests)

setInterval(printCounts, 1000)

bench = (index = 0, concurrents = concurrentRequests, max = maxRequests, callback = null) ->
  return callback(null) if index > (max - concurrents)
  
  async.forEach([1..concurrents], request, (err) ->
    return callback(err) if err
    
    bench(index + concurrents, concurrents, max, callback)
  )

bench(0, concurrentRequests, maxRequests, (err) ->
  throw err if err
  
  console.log("completed #{responseCount} out of #{maxRequests}")
  process.exit()
)