/*global window, jQuery */
(function (scope, $) {
    'use strict';
    scope.LayoutManager = (function () {
        var layoutManager = {
            drag: false,
            draggable: null
        };

        layoutManager.move = function (posX, posY) {
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
            }

            if (this.draggable) {
                this.draggable.addClass('dragging');
            }

            $('.circle').hide();
            $('.hand').removeClass('hidden');
            this.move(posX, posY);

            return true;
        };

        layoutManager.release = function () {
            $('.hand').addClass('hidden');
            $('.circle').show();

            this.drag = false;

            return true;
        };

        return layoutManager;
    }());
}(window, jQuery));