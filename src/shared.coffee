module.exports = {}

module.exports.docopt2obj = (opts) ->
  o = {
    requests: opts["-n"],
    concurrents: opts["-c"],
    host: opts["--host"],
    admin: opts["--admin"],
    server: opts["--server"],
    test: opts["--test"],
    verbose: opts["--verbose"]
  }
  return o