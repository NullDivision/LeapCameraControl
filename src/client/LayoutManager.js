define(['vendor/lodash', 'React'], function (_, React) {
    var config = {};
    var acceptedTypes = ['image/jpeg'];

    function validateFeed (feed) {
        // test type
        if (!_.has(feed, 'type') || !_.includes(acceptedTypes, feed.type)) {
            throw new Error('Invalid feed parameter: type');
        }
    };

    function generateImageFeed (feed) {
        React.render(React.createElement('div', null, 'test'), document.getElementById('camera-feeds'));
    }

    function generateFeed (feed) {
        validateFeed(feed);

        switch (feed.type) {
            case 'text/plain':
                generateImageFeed(feed);
            break;
        }
    };

    return {
        get: function (attr) {
            return config.attr;
        },
        addFeed: function (feed) {
            if (_.isEmpty(feed)) {
                throw new Error('Dataset required');
            }

            generateFeed(feed);

            return false;
        }
    };
});
