// Generated by CoffeeScript 1.3.3
(function() {
  var CMinion, MAXROUTES, Minion, i, port, r, restify, server, _i;

  restify = require("restify");

  CMinion = require("../../minion");

  Minion = new CMinion();

  server = restify.createServer();

  server.use(restify.queryParser());

  port = process.env.PORT || 3000;

  MAXROUTES = process.env.MAXROUTES || 100000;

  for (i = _i = 0; 0 <= MAXROUTES ? _i <= MAXROUTES : _i >= MAXROUTES; i = 0 <= MAXROUTES ? ++_i : --_i) {
    r = "/" + i;
    server.get(r, function(req, res) {
      res.send("Hello World.");
      return Minion.logRequest(req.query);
    });
  }

  Minion.started();

  server.listen(port, function() {
    return console.log("Listening on port " + port);
  });

}).call(this);
