docopt2obj = (opts) ->
  obj = {
    requests: opts["-n"],
    concurrents: opts["-c"],
    host: opts["--host"],
    admin: opts["--admin"],
    server: opts["--server"],
    test: opts["--test"],
    verbose: opts["--verbose"]
  }

module.exports = {}
module.exports.docopt2obj = docopt2obj

