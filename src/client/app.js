require.config({
    baseUrl: 'dist/assets/js',
    paths: {
        'SockJS': '//cdn.jsdelivr.net/sockjs/1.0.0/sockjs.min',
        'React': '//fb.me/react-with-addons-0.13.3'
    }
});

require(['LayoutManager', 'SockJS'], function (LayoutManager, SockJS) {
    var socketConnect = function () {
        var feeds = [];

        console.log('Attempting connection');

        var socket = new SockJS('http://localhost:9000/ws/', null, {transports: 'websocket'});

        socket.onopen = function () {
            console.log('Connection established');
        };
        socket.onmessage = function (message) {
            var messageData = JSON.parse(message.data);
            if ('push' === messageData.action) {
                feeds.push(messageData.content);
                LayoutManager.addFeed(feeds);
            }
        }
    };

    socketConnect();
});
