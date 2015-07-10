define(['SocketProxy'], function (SocketProxy) {
    describe('Socket Proxy', function() {
        describe('should fail init', function() {
            it('when invalid config is passed', function() {
                expect(function () {SocketProxy.init({});}).toThrow(new Error('Invalid config state'));
            });
        });
    });
});
