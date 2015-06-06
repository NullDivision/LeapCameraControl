/*global window, jQuery */
(function (scope, $) {
    'use strict';
    scope.LayoutManager = (function () {
        var layoutManager = {
            drag: false,
            draggable: null
        };
        var t;

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

        layoutManager.pull = function (posZ) {
            var scale       = 1,
                scaleLimit  = 4.1,
                adjustment  = parseFloat(0.4),
                posZReal    = posZ + 1,
                posZPercent = posZReal * 100 / 2;

            if (!this.draggable) {
                return false;
            }

            scale = (posZPercent * scaleLimit / 100) + adjustment;

            this.draggable.css({transform: 'scale(' + scale + ')'});

            return true;
        };

        layoutManager.circle = function(posX, posY, rotationRad, socket) {
            var element = window.document.elementsFromPoint(posX, posY);
            var rotation = rotationRad * (180/3.14);
            console.log(rotation);
            if ($(element).hasClass('feed-img')) {
                if (rotation < -50) {
                    // if(t != null) { clearTimeout(t);}
                    // t = setTimeout(function(){
                        send('{"cmd":1, "usr":'+$(element).attr('usr')+"}");//}
                    // , 500);
                }
                if (rotation > 50) {
                    // if(t != null) { clearTimeout(t);}
                    // t = setTimeout(function(){
                        send('{"cmd":2, "usr":'+$(element).attr('usr')+"}");//}
                    // , 500);
                }
                
            }
        };
        return layoutManager;
    }());
}(window, jQuery));