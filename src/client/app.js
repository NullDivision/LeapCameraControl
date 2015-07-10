require.config({
    baseUrl: 'dist/assets/js',
    paths: {
        'SockJS': '//cdn.jsdelivr.net/sockjs/1.0.0/sockjs.min'
    }
});

require(['LayoutManager', 'SockJS'], function (LayoutManager, SockJS) {
    var socket = new SockJS('http://localhost:9000/');
    socket.onopen = function () {
        console.log('open');
    };
});
