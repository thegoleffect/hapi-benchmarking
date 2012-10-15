_ = require("underscore")
EventEmitter = require("events").EventEmitter
Hapi = require("hapi")
uuid = require("node-uuid")

class Master extends EventEmitter
  constructor: (@port = 8080, options = {}) ->
    @options = @opts(options)
    @benchmark = null
    @startAdmin()
  
  _defaultOptions: {
    host: "localhost",
    serverFile: "../support/hapi/helloworld.coffee"
  }
  
  opts: (options) ->
    options.port = @port
    @options = _.extend({}, @_defaultOptions, options)
  
  register: (query, id = null) ->
    # console.log("register", @benchmark)
    id = id || uuid.v4()
    if @benchmark != null
      # console.log("benchmark exists")
      return "Benchmark in progress, please wait until finished"
    
    @benchmark = {
      id: id,
      query: query
    }
    return @benchmark
  
  unregister: (id = null) ->
    # console.log("unregister", id, @benchmark)
    return "No such benchmark found by that id (#{id})" if id == null or (@benchmark and @benchmark.id and @benchmark.id != id)
    
    benchmark = @benchmark
    @benchmark = null
    
    # TODO: write backup of benchmark data to disk
    return benchmark
  
  statistics: (data) ->
    return {} # TODO:
    
  startAdmin: () ->
    self = this
    
    @server = new Hapi.Server(@options.host, @options.port)
    starter = {
      method: "GET",
      path: "/bench/start",
      config: {
        query: {
          n: Hapi.Types.Number().required(),
          c: Hapi.Types.Number(),
          id: Hapi.Types.String()
        },
        handler: (req) ->
          id = self.register(req.query, req.id || null)
          if typeof id == "string"
            # id = Hapi.Error.create(id, 500, "Benchmark In Progress")
            id = Hapi.Error.badRequest(id)
          
          req.reply(id)
      }
    }
    
    finisher = {
      method: "GET",
      path: "/bench/finish",
      config: {
        query: {
          id: Hapi.Types.String().required()
        },
        handler: (req) ->
          id = req.query.id
          data = self.unregister(id)
          
          if typeof data == "string"
            stats = Hapi.Error.badRequest(data)
          else
            stats = self.statistics(data)
          
          req.reply(stats)
      }
    }
    
    @server.addRoute(starter)
    @server.addRoute(finisher)
    @server.start()
  
module.exports = Master