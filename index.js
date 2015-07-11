// get web framework
var app = require('express')();
app.set('view engine', 'jade');

// start services
var server = require('http').createServer(app);
var sockjs = require('sockjs');

var echo = sockjs.createServer({ sockjs_url: 'http://cdn.jsdelivr.net/sockjs/0.3.4/sockjs.min.js' });
echo.on('connection', function(conn) {
    conn.on('data', function(message) {
        conn.write(message);
    });
    conn.on('close', function() {});
});

app.get('/', function (request, response) {
    console.log('Registry page');
    response.render('registry');
});

// chat server init
echo.installHandlers(server, {prefix: 'socks/'});
server.listen(9000, '0.0.0.0');
