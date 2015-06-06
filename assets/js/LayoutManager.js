/*global window, jQuery */
(function (scope, $) {
    'use strict';
    scope.LayoutManager = (function () {
        var layoutManager = {
            drag: false,
            draggable: null
        };

        layoutManager.grab = function (posX, posY) {
            var i,
                elements = window.document.elementsFromPoint(posX, posY),
                interactables = ['.feed-container'];

            for (i = interactables.length - 1; i >= 0; i -= 1) {
                this.draggable = $(elements).filter(interactables[i]);
            }

            if (this.draggable) {
                this.draggable.addClass('dragging');

                return true;
            }

            return false;
        };

        return layoutManager;
    }());
}(window, jQuery));