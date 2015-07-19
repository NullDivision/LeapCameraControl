'use strict'

// fix for missing phantomjs bind function
if (typeof Function.prototype.bind != 'function') {
    Function.prototype.bind = function bind(obj) {
        var args = Array.prototype.slice.call(arguments, 1),
            self = this,
            nop = function() {
            },
            bound = function() {
                return self.apply(
                    this instanceof nop ? this : (obj || {}), args.concat(
                        Array.prototype.slice.call(arguments)
                    )
                );
            };
        nop.prototype = this.prototype || {};
        bound.prototype = new nop();
        return bound;
    };
}

define(['LayoutManager'], function (LayoutManager) {
    describe('LayoutManager', function () {
        describe('when instancing a feed', function () {
            it('should fail if no data', function () {
                expect(LayoutManager.addFeed).toThrow(new Error('Dataset required'));
            });

            it('should fail on invalid feed information', function () {
                expect(
                    function () {LayoutManager.addFeed({type: 'text/plain'});}
                ).toThrow(new Error('Invalid feed parameter: type'));
            });

            it('should generate a new feed in layout', function () {
                // create temporary container
                var feedEntity,
                    parentContainer = document.createElement('div');

                parentContainer.id = LayoutManager.get('container').id;
                document.body.appendChild(parentContainer);

                LayoutManager.addFeed({
                    type: 'image/jpeg',
                    url: '//lh4.googleusercontent.com/-jeaZZDVKcI0/AAAAAAAAAAI/AAAAAAAAAAA/LRfaZ1X_izQ/s32-c/photo.jpg'
                });

                feedEntity = parentContainer.querySelector('.' + LayoutManager.get('feedClass'));
                expect(feedEntity.length).not.toBe(null);
                expect(feedEntity.querySelector('img').length).not.toBe(null);
            });
        });
    });
});
