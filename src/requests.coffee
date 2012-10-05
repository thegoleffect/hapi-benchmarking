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
latency = new Array(maxRequests)

request = (i, callback) ->
  i = requestsCount
  requestsCount++
  start_time = Date.now()
  r = http.request(options, (res) ->
    res.on("end", () ->
      end_time = Date.now()
      latency[i] = end_time - start_time
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

mean = (arr) ->
  return arr.reduce((a,b) -> return a + b) / arr.length

median = (arr) ->
  sortedArr = arr.slice(0).sort((a,b) -> return a - b)
  midpt = (sortedArr.length / 2) >> 0
  if sortedArr.length % 2 == 1
    return sortedArr[midpt]
  else
    return mean([sortedArr[midpt - 1], sortedArr[midpt]])

stdDev = (a) ->
  arr = a.slice(0)
  arrMean = mean(arr)
  differences = arr.map((d) -> return +(Math.pow(d - arrMean, 2)).toFixed(2))
  sumDiff = differences.reduce((a,b)-> return a+b)
  variance = (1 / (arr.length - 1)) * sumDiff
  sdev = Math.sqrt(variance)
  return sdev

printLatency = () ->
  min = Math.min.apply(this, latency)
  max = Math.max.apply(this, latency)
  lmean = mean(latency)
  lmedian = median(latency)
  lstddev = stdDev(latency)
  
  console.log("Latencies:")
  console.log("min =", min)
  console.log("max =", max)
  console.log("mean =", lmean)
  console.log("median =", lmedian)
  console.log("std dev =", lstddev)

bench(0, concurrentRequests, maxRequests, (err) ->
  throw err if err
  
  console.log("completed #{responseCount} out of #{maxRequests}")
  printLatency()
  process.exit()
)