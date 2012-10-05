EventEmitter = require("events").EventEmitter
# colors = require("colors")

class RequestCounter extends EventEmitter
  constructor: (@counts = {}) ->
    @mem = {}
    @load = {}
    
    @on("count", @onCount)
    @on("mem", @onMem)
    @on("load", @onLoadAvg)
  
  onCount: (n) =>
    @counts[n.ts] = 0 if !@counts.hasOwnProperty(n.ts)
    @counts[n.ts]+= n.increment || 1
  
  onMem: (ts, data) =>
    @mem[ts] = data
  
  onLoadAvg: (ts, data) =>
    @load[ts] = data
  
  print: () =>
    console.log((new Date()).toLocaleTimeString(), JSON.stringify(@counts, null, 2))
  
  printMem: () =>
    console.log("==========")
    console.log("mem: ")
    console.log(@mem)
    
  printLoadAvg: () =>
    console.log("==========")
    console.log("load: ")
    console.log(@load)
  
  printStatistics: () =>
    keys = Object.keys(@counts)
    sum = 0
    for key in keys
      sum += @counts[key]
    intKeys = keys.map((d) -> return +d)
    min = Math.min.apply(this, intKeys)
    max = Math.max.apply(this, intKeys)
    avg = sum / (max - min)
    @print()
    console.log("avg rps = ", avg)
    @printMem()
    @printLoadAvg()
    

module.exports = RequestCounter