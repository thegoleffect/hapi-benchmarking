// Generated by CoffeeScript 1.3.3
(function() {
  var CMinion, Hapi, MAXROUTES, Minion, dns, host, i, os, port, r, route, server, _i;

  dns = require("dns");

  os = require("os");

  Hapi = require("hapi");

  host = process.env.HOST || 'localhost';

  port = process.env.PORT || 3000;

  CMinion = require("../../minion");

  Minion = new CMinion();

  MAXROUTES = process.env.MAXROUTES || 100000;

  server = new Hapi.Server(host, port);

  route = function(p) {
    if (p == null) {
      p = "/";
    }
    return {
      method: "GET",
      path: p,
      config: {
        query: {
          id: Hapi.Types.String()
        },
        handler: function(req) {
          req.reply("Hello World.");
          return Minion.logRequest(req.query);
        }
      }
    };
  };

  for (i = _i = 0; 0 <= MAXROUTES ? _i <= MAXROUTES : _i >= MAXROUTES; i = 0 <= MAXROUTES ? ++_i : --_i) {
    r = "/" + i;
    server.addRoute(route(r));
  }

  Minion.started();

  server.start();

}).call(this);
