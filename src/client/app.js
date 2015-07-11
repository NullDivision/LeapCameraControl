require.config({
    baseUrl: 'dist/assets/js',
    paths: {
        'SockJS': '//cdn.jsdelivr.net/sockjs/1.0.0/sockjs.min'
    }
});

require(['LayoutManager', 'SockJS'], function (LayoutManager, SockJS) {
    var socketConnect = function () {
        console.log('Attempting connection');

        var socket = new SockJS('http://localhost:9000/');

        socket.onopen = function () {
            console.log('Connection established');
        };
    };

    socketConnect();
});
