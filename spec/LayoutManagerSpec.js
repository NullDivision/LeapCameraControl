'use strict'

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
        });
    });
});
