// get web framework
var express    = require('express'),
    bodyParser = require('body-parser'),
    sockjs     = require('sockjs');
var app = express();

app.set('view engine', 'jade');
app.use('/dist', express.static('dist'));
app.use('/old_dist', express.static('assets'));

// start services
var server = require('http').createServer(app);

var echo = sockjs.createServer();
echo.on('connection', function(conn) {
    conn.on('data', function(message) {
        conn.write(message);
    });
    conn.on('close', function() {});
});

app.get('/', function (request, response) {
    response.render('index.jade');
});
app.get('/registry', function (request, response) {
    response.render('registry');
});
app.get('/add-image', function (request, response) {
    response.render('add_image');
});
app.post('/add-image', bodyParser.json(), function (request, response) {
    // emit new image to clients
    echo.emit(JSON.stringify({action: 'push', content: {type: 'text/plain', data: request.body.url}}))

    response.render('add_image');
});

// chat server init
server.listen(9000);
echo.installHandlers(server, {prefix: '/ws'});
