/*global window, jQuery */
(function (scope, $) {
    'use strict';
    scope.LayoutManager = (function () {
        var layoutManager = {
            drag: false,
            draggable: null
        };

        layoutManager.move = function (posX, posY) {
            if (!this.drag) {
                return false;
            }

            $('.hand').css({top: posY + 'px', left: posX + 'px'});
            this.draggable.css({top: posY + 'px', left: posX + 'px'});
        };

        layoutManager.grab = function (posX, posY) {
            var i,
                elements = window.document.elementsFromPoint(posX, posY),
                interactables = ['.feed-container'];

            if (this.drag) {
                return false;
            }

            for (i = interactables.length - 1; i >= 0; i -= 1) {
                this.draggable = $(elements).filter(interactables[i]);
                if (this.draggable) {
                    break;
                }
            }

            if (this.draggable) {
                this.draggable.addClass('dragging').appendTo('#page');
                this.drag = true;

                $('.circle').hide();
                $('.hand').removeClass('hidden');
            }

            this.move(posX, posY);

            return true;
        };

        layoutManager.release = function (posX, posY) {
            var container = $(window.document.elementsFromPoint(posX, posY)).filter('.feed-column');

            $('.hand').addClass('hidden');
            $('.circle').show();

            if (this.draggable) {
                if ('main-camera' === container.attr('id')) {
                    this.draggable.appendTo(container);
                } else {
                    this.draggable.prependTo('#camera-feeds');
                }

                this.draggable.removeClass('dragging').removeAttr('style');
            }

            this.drag = false;
            this.draggable = null;

            return true;
        };

        return layoutManager;
    }());
}(window, jQuery));