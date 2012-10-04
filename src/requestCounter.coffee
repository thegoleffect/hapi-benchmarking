EventEmitter = require("events").EventEmitter
# colors = require("colors")

class RequestCounter extends EventEmitter
  constructor: (@counts = {}) ->
    @on("count", @onCount)
  
  onCount: (n) =>
    @counts[n.ts] = 0 if !@counts.hasOwnProperty(n.ts)
    @counts[n.ts]+= n.increment || 1
  
  print: () =>
    console.log((new Date()).toLocaleTimeString(), JSON.stringify(@counts, null, 2))
  
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
    
    console.log("avg = ", avg)
    

module.exports = RequestCounter