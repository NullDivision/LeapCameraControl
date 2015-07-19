define(['vendor/lodash', 'React'], function (_, React) {
    var config = {
        feedClass: 'feed-instance',
        container: { id: 'camera-feeds' }
    };
    var acceptedTypes = ['image/jpeg'];

    function validateFeed (feed) {
        // test type
        if (!_.has(feed, 'type') || !_.includes(acceptedTypes, feed.type)) {
            throw new Error('Invalid feed parameter: type');
        }
    };

    function generateImageFeed (feed) {
        React.render(
            React.createElement(
                'div',
                { className: config.feedClass },
                React.createElement('image', { source: { uri: feed.url } })
            ),
            document.getElementById(config.container.id)
        );
    }

    function generateFeed (feed) {
        validateFeed(feed);

        switch (feed.type) {
            case 'image/jpeg':
                generateImageFeed(feed);
            break;
        }
    };

    return {
        get: function (attr) {
            return config[attr];
        },
        addFeed: function (feed) {
            if (_.isEmpty(feed)) {
                throw new Error('Dataset required');
            }

            return generateFeed(feed);
        }
    };
});
