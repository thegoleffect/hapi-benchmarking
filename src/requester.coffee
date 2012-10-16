_ = require("underscore")
async = require("async")
http = require("http")
request = require("request")
url = require("url")
Statistics = require("./statistics")

class Requester extends Statistics
  constructor: (options) ->
    @options = _.extend({}, @_options, @docopt2obj(options))
    
    http.Agent.defaultMaxSockets = @options.concurrents
    http.globalAgent.maxSockets = @options.concurrents
    
    @latency = new Array(@options.requests)
    @requestCounter = 0
    @responseCounter = 0
  
  _options: {
    requests: 1000,
    concurrents: 50,
    ssl: false,
    debug: false
  }
  
  docopt2obj: (opts) ->
    obj = {
      requests: opts["-n"],
      concurrents: opts["-c"],
      host: opts["--host"],
      admin: opts["--admin"],
      server: opts["--server"],
      test: opts["--test"],
      verbose: opts["--verbose"]
    }
  
  bench: (index, concurrents, max, callback) ->
    # return callback(null) if index > (max - concurrents)
  
    # async.forEach([1..concurrents], request, (err) =>
    #   return callback(err) if err
      
    #   @bench(index + concurrents, concurrents, max, callback)
    # )
    callback(null)
  
  initBench: (callback) ->
    self = this
    url = [@options.admin, "bench", "start"].join("/")
    url += "?n=#{@options.requests}&c=#{@options.concurrents}"
    opts = {
      method: "GET",
      uri: url
    }
    
    console.log(opts) if @options.debug
    
    request(opts, (err, response, body) ->
      throw err if err
      try
        data = JSON.parse(body)
      catch e
        throw e
      
      console.log("data", data) if self.options.debug
      
      callback(err, data.id, data)
    )
  
  finishBench: (id, callback) ->
    url = [@options.admin, "bench", "finish"].join("/")
    url += "?id=#{id}"
    opts = {
      method: "GET",
      uri: url
    }
    request(opts, (err, response, body) ->
      throw err if err
      
      try
        data = JSON.parse(body)
      catch e
        throw e
      
      callback(err, data)
    )
  
  start: () ->
    self = this
    console.log("start()") if self.options.debug
    
    @initBench((err, id) ->
      throw err if err
      console.log("initBench with id = #{id}") if self.options.debug
      
      self.bench(0, self.concurrents, self.requests, (err) =>
        throw err if err
        
        self.finishBench(id, (err, response) =>
          throw err if err
          
          console.log("finished bench")
          console.log(response)
          # print statistics?
          
          # backup to file
        )
      )
    )

module.exports = Requester