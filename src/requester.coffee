_ = require("underscore")
async = require("async")
http = require("http")
request = require("request")
Statistics = require("./statistics")

class Requester extends Statistics
  constructor: (options) ->
    @options = _.extend({}, @_options, options)
    
    http.Agent.defaultMaxSockets = @options.concurrents
    http.globalAgent.maxSockets = @options.concurrents
    
    @latency = new Array(@options.requests)
    @requestCounter = 0
    @responseCounter = 0
  
  _options: {
    requests: 1000,
    concurrents: 50
  }
  
  bench: (index, concurrents, max, callback) =>
    return callback(null) if index > (max - concurrents)
  
    async.forEach([1..concurrents], request, (err) =>
      return callback(err) if err
      
      @bench(index + concurrents, concurrents, max, callback)
    )
  
  start: () ->
    bench(0, @concurrents, @requests, (err) ->
      throw err if err
      
      # print statistics?
      
      # backup to file
    )

module.exports = Requester