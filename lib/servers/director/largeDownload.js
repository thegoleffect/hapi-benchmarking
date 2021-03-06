// Generated by CoffeeScript 1.3.3
(function() {
  var CMinion, Minion, director, download, http, port, router, server;

  http = require("http");

  director = require("director");

  CMinion = require("../../minion");

  Minion = new CMinion();

  download = function() {
    var self;
    self = this;
    return fs.readFile(filepath, function(err, data) {
      if (err) {
        throw err;
      }
      self.res.writeHead(200, {
        'Content-Type': 'text/plain'
      });
      self.res.send(data.toString());
      return Minion.logRequest(this.req, true);
    });
  };

  router = new director.http.Router({
    "/": {
      get: download
    }
  });

  server = http.createServer(function(req, res) {
    return router.dispatch(req, res, function(err) {
      if (err) {
        res.writeHead(404);
        return res.end();
      }
    });
  });

  Minion.started();

  port = process.env.PORT || 3000;

  server.listen(port);

}).call(this);
