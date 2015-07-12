require.config({
    baseUrl: 'dist/assets/js',
    paths: {
        'SockJS': '//cdn.jsdelivr.net/sockjs/1.0.0/sockjs.min',
        'React': '//fb.me/react-with-addons-0.13.3.js'
    }
});

require(['LayoutManager', 'SockJS'], function (LayoutManager, SockJS) {
    var socketConnect = function () {
        console.log('Attempting connection');

        var socket = new SockJS('http://localhost:9000/ws/', null, {transports: 'websocket'});

        socket.onopen = function () {
            console.log('Connection established');
        };
        socket.onmessage = function (message) {
            console.log(message);
        }
    };

    socketConnect();
});
