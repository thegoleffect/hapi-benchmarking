Master = require("./master.coffee")

options = {}
m = new Master(process.env.PORT || null, options)

# {exec, spawn, fork} = require("child_process")
# RequestCounter = require("./requestCounter")

# IS_REQUESTING = false
# PRINT_INTERVAL = 5000
# METRICS_INTERVAL = 5000

# rc = new RequestCounter()
# t = setInterval(rc.print, PRINT_INTERVAL)

# cleanup = () ->
#   clearInterval(t)
#   clearInterval(metricsTimer)
#   requests.kill() if IS_REQUESTING == true
  
#   console.log("performing cleanup")
#   process.nextTick((() ->
#     rc.printStatistics()
    
#     server.kill()
#   ))

# onMessage = (m) ->
#   ts = Date.now()/1000>>0
  
#   if m.hasOwnProperty("status")
#     return cleanup() if m.status == -1
#     return rc.emit("count", {ts: ts, increment: m.increment || null}) if m.status == 0
  
#   if m.hasOwnProperty("action")
#     action = m.action
#     switch action
#       when "mem"
#         rc.emit("mem", ts, m.data)
#       when "load"
#         rc.emit("load", ts, m.data)
#       else
#         throw "unknown action specified: " + action



# server = fork(__dirname + "/server.coffee")
# server.on("message", onMessage)

# requestStats = () ->
#   server.send({action: "mem"})
#   server.send({action: "load"})

# metricsTimer = setInterval(requestStats, METRICS_INTERVAL)

# if IS_REQUESTING == true
#   requests = fork(__dirname + "/requests.coffee")
#   requests.on("message", onMessage)
# else
#   # do nothing

# process.on("SIGINT", () ->
#   cleanup()
# )