module.exports = request = (options, i, callback) ->
  # i = requestsCount
  # requestsCount++
  # start_time = Date.now()
  # r = http.request(options, (res) ->
  #   res.on("end", () ->
  #     end_time = Date.now()
  #     latency[i] = end_time - start_time
  #     responseCount++
  #     callback() if callback and typeof callback == "function"
  #   )
  # )
  # r.end()