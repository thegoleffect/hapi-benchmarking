class Statistics
  min: (arr) -> return Math.min.apply(this, latency)
  
  max: (arr) -> return Math.max.apply(this, latency)
  
  mean: (arr) ->
    return arr.reduce((a,b) -> return a + b) / arr.length

  median: (arr) ->
    sortedArr = arr.slice(0).sort((a,b) -> return a - b)
    midpt = (sortedArr.length / 2) >> 0
    if sortedArr.length % 2 == 1
      return sortedArr[midpt]
    else
      return mean([sortedArr[midpt - 1], sortedArr[midpt]])

  stdDev: (a) ->
    arr = a.slice(0)
    arrMean = mean(arr)
    differences = arr.map((d) -> return +(Math.pow(d - arrMean, 2)).toFixed(2))
    sumDiff = differences.reduce((a,b)-> return a+b)
    variance = (1 / (arr.length - 1)) * sumDiff
    sdev = Math.sqrt(variance)
    return sdev

module.exports = Statistics