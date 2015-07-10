define('SocketProxy', ['vendor/lodash'], function (_) {
    var publicCalls = {};

    publicCalls.init = function (config) {
        if (_.isEmpty(config)) {
            throw new Error('Invalid config state');
        }
    };

    return publicCalls;
});
