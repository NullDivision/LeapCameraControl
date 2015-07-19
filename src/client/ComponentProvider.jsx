define(['React', 'vendor/lodash'], function (React, _) {
    var Feedlist = React.createClass({
        render: function () {
            var i = 0;

            return <div>
                {
                    _.map(
                        this.props.feeds,
                        function (feed) {
                            return <div key={i++} className={this.props.className}><img src={feed.src} /></div>;
                        },
                        this
                    )
                }
            </div>;
        }
    });

    function generateFeeds (context) {
        React.render(
            <Feedlist className={context.feedClass} feeds={context.feeds} />,
            document.getElementById(context.container.id)
        );
    }

    return { generateFeeds: generateFeeds }
});
