_ = require("underscore")
EventEmitter = require("events").EventEmitter
Hapi = require("hapi")
uuid = require("node-uuid")
fs = require("fs")
path = require("path")
{exec, spawn, fork} = require("child_process")

class Master extends EventEmitter
  constructor: (@port = 8080, options = {}) ->
    @init(options)
    @startAdmin()
  
  _defaultOptions: {
    host: "localhost",
    filePath: "../support/",
    server: "hapi",
    serverFile: "helloworld"
  }
  
  init: (options) ->
    @options = @_opts(options)
    @benchmark = null
    process.on("SIGINT", @cleanup)
  
  _opts: (options) ->
    options.port = @port
    @options = _.extend({}, @_defaultOptions, options)
  
  register: (query, id = null) ->
    id = id || uuid.v4()
    if @benchmark != null
      return Hapi.Error.badRequest("Benchmark in progress, please wait until finished")
    
    @benchmark = {
      id: id,
      query: query
    }
    return @benchmark
  
  unregister: (id = null) ->
    return Hapi.Error.badRequest("No such benchmark found by that id (#{id})") if id == null or (@benchmark and @benchmark.id and @benchmark.id != id)
    benchmark = finalizeData()
    stats = @statistics(benchmark)
    return stats
  
  finalizeData: () ->
    benchmark = @benchmark
    @benchmark = null
    # TODO: write backup of benchmark data to disk
    return benchmark
  
  statistics: (data) ->
    console.log(data)
    return {} # TODO:
  
  aggregate: (action, timestamp, increment = 1) ->
    if not @benchmark.hasOwnProperty(action)
      @benchmark[action] = {} 
      @benchmark[action][timestamp] = 0
    @benchmark[action][timestamp] += increment
  
  record: (action, timestamp, data = true) ->
    return null if @benchmark == null
    @benchmark[action] = {} if not @benchmark.hasOwnProperty(action)
    @benchmark[action][timestamp] = data
    
  now: () -> return Date.now()/1000>>0
    
  onMessage: (m) =>
    ts = @now()
    switch m.action
      when "request"
        @aggregate(m.action, ts, m.data)
      when "mem", "load"
        @record(m.action, ts, m.data)
      when "started", "ended"
        @record(m.action, ts)
      else
        console.log("unspecified action: #{m.action}")
  
  cleanup: () =>
    @stop()
    process.nextTick(() ->
      process.exit()
    )
    # clear timers, etc
  
  start: (settings) ->
    @stop() if @server != null
    @server = fork(path.join(@options.filePath, settings.server, settings.test))
    @server.on('message', @onMessage)
  
  stop: () ->
    @record("ended", @now())
    if @server
      @server.removeAllListeners()
      @server.kill()
      @server = null
    return @finalizeData()
    
  startAdmin: () ->
    self = this
    
    @admin = new Hapi.Server(@options.host, @options.port)
    initializer = {
      method: "GET",
      path: "/bench/init",
      config: {
        query: {
          server: Hapi.Types.String().required(),
          test: Hapi.Types.String()
        },
        handler: (req) ->
          status = self.start(req.query)
          req.reply(status)
      }
    }
    
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
          stats = self.unregister(req.query.id)
          req.reply(stats)
      }
    }
    
    @admin.addRoute(initializer)
    @admin.addRoute(starter)
    @admin.addRoute(finisher)
    @admin.start()
  
module.exports = Master