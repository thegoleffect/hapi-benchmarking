{exec, spawn, fork} = require("child_process")
RequestCounter = require("./requestCounter")

rc = new RequestCounter()
# t = setInterval(rc.print, 10000)

cleanup = () ->
  # clearInterval(t)
  # requests.kill()
  
  console.log("performing cleanup")
  process.nextTick((() ->
    rc.printStatistics()
    
    server.kill()
  ))

onMessage = (m) ->
  return cleanup() if m.status == -1
  return rc.emit("count", {ts: Date.now()/1000>>0}) if m.status == 0

server = fork(__dirname + "/server.coffee")
server.on("message", onMessage)

# requests = fork(__dirname + "/requests.coffee")
# requests.on("message", onMessage)

process.on("SIGINT", () ->
  cleanup()
)