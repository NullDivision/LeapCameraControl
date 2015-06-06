var options = {enableGestures: true};

Leap.loop(options, function (frame) {
    if (frame.pointables.length > 0) {
        var i = 1;
        frame.pointables.forEach(function (pointable) {
            var position = pointable.stabilizedTipPosition;
            var normalized = frame.interactionBox.normalizePoint(position);
            var x = window.innerWidth * normalized[0];
            var y = window.innerHeight * (1 - normalized[1]);
            $('.finger' + i).css({
                left: x,
                top: y
            });
            i++;
        });

    }
});