define(['vendor/lodash', 'ComponentProvider', 'React'], function (_, ComponentProvider, React) {
    var config = {
        feedClass: 'feed-instance',
        container: { id: 'camera-feeds' }
    };
    var acceptedTypes = ['image/jpeg'];

    function validateFeed (feeds) {
        if (!_.isArray(feeds)) {
            throw new Error('Feeds must be of type [Array]');
        }

        _.forEach(feeds, function (feed) {
            // test type
            if (!_.has(feed, 'type') || !_.includes(acceptedTypes, feed.type)) {
                throw new Error('Invalid feed parameter: type');
            }
        });
    };

    function generateFeed (feeds) {
        validateFeed(feeds);

        ComponentProvider.generateFeeds({feeds: feeds, container: config.container, feedClass: config.feedClass});
    };

    return {
        get: function (attr) {
            return config[attr];
        },
        addFeed: function (feeds) {
            if (_.isEmpty(feeds)) {
                throw new Error('Dataset required');
            }

            return generateFeed(feeds);
        }
    };
});
