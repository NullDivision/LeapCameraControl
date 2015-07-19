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

            it('should fail if feed is not an array', function () {
                expect(
                    function () {LayoutManager.addFeed({type: 'text/plain'});}
                ).toThrow(new Error('Feeds must be of type [Array]'));
            });

            it('should fail if invalid feed type', function () {
                expect(
                    function () {LayoutManager.addFeed([{type: 'text/plain'}]);}
                ).toThrow(new Error('Invalid feed parameter: type'));
            });

            it('should generate a new feed in layout', function () {
                var feedEntity, parentContainer;

                // create temporary container
                parentContainer = document.createElement('div')
                parentContainer.id = LayoutManager.get('container').id;
                document.body.appendChild(parentContainer);

                LayoutManager.addFeed([
                    {type: 'image/jpeg', url: '//localhost/photo_1.jpg'},
                    {type: 'image/jpeg', url: '//localhost/photo_2.jpg'},
                    {type: 'image/jpeg', url: '//localhost/photo_3.jpg'},
                    {type: 'image/jpeg', url: '//localhost/photo_4.jpg'}
                ]);

                expect(
                    parentContainer.querySelectorAll('.' + LayoutManager.get('feedClass') + ' img').length
                ).toBe(4);
            });
        });
    });
});
