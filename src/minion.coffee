os = require("os")

class Minion
  constructor: () ->
    process.on('message', (msg) ->
      switch msg.action
        when "mem"
          data = process.memoryUsage()
        when "load"
          data = os.loadavg()
        else
          data = {}
      
      process.send({action: msg.action, data: data}) if process.send
    )
  
  log: (action, data) ->
    process.send({action: action, data: data}) if process.send
  
  logRequest: () ->
    @log("request", 1)
  
module.exports = Minion