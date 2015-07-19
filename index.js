// get web framework
var express    = require('express'),
    bodyParser = require('body-parser'),
    sockjs     = require('sockjs');
var app = express();

app.set('view engine', 'jade');
app.use('/dist', express.static('dist'));
app.use('/old_dist', express.static('assets'));
app.use('/node_modules', express.static('node_modules'));

// start services
var server = require('http').createServer(app);

var connections = [];

var echo = sockjs.createServer();
echo.on('connection', function(conn) {
    connections.push(conn);

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
app.post('/add-image', bodyParser.json(), bodyParser.urlencoded({ extended: true }), function (request, response) {
    // emit new image to clients
    console.log('New feed added');
    for (var i = connections.length - 1; i >= 0; i--) {
        connections[i].write(JSON.stringify({action: 'push', content: {type: 'image/jpeg', src: request.body.url}}));
    };

    response.render('add_image');
});

// chat server init
server.listen(9000);
echo.installHandlers(server, {prefix: '/ws'});
