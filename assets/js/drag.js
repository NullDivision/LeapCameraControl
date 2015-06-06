var options = {enableGestures: true};

LayoutManager.grabbed = LayoutManager.drag;
LayoutManager.pull = function(z){
    console.log("pulled:");
};
LayoutManager.swipe = function (x,y){
    console.log("swiped");
};
LayoutManager.tap = function (x,y){
    console.log("tapped");
};
LayoutManager.keyTap = function (x,y){
    console.log("keytap");
};
LayoutManager.circle = function (x,y){
    console.log("circle");
};

function reloadImage() {
    if (!$("#image")[0].complete){
        return;
    }
    var url = "http://10.0.0.21:8080/img.jpg?" + Math.floor(Date.now() / 1000);
    try{
        $("#image").attr('src', url);
    } catch( e){
        console.log(e);
    }

}
setInterval(reloadImage, 20);

var marginTop = 0;
var grabbed = false;
Leap.loop(options, function (frame) {
    var leap = this;

    if (frame.pointables.length > 0) {
        var i = 1;
        frame.pointables.forEach(function (pointable) {
            var position = pointable.stabilizedTipPosition;
            var normalized = frame.interactionBox.normalizePoint(position);
            var x = window.innerWidth * normalized[0];
            var y = window.innerHeight * (1 - normalized[1])+marginTop;
            $('.finger' + i).css({
                left: x,
                top: y
            });
            i++;
        });
    }

    for (var i = 0, len = frame.hands.length; i < len; i++) {
        hand = frame.hands[i];
        var normalized = frame.interactionBox.normalizePoint(hand.palmPosition);
        var x = window.innerWidth * normalized[0];
        var y = window.innerHeight * (1 - normalized[1])+marginTop;
        var z = normalized[2];

        if(hand.confidence > 0.2){
            if (hand.grabStrength >= 0.6) {
                LayoutManager.grab(x, y);
            } else {
                LayoutManager.release(x, y);
            }
        }
        LayoutManager.move(x, y);
        if (z >= 1) {
            LayoutManager.pull(z);
        }
    }
    frame.gestures.forEach(function(gesture){
        switch (gesture.type){
          case "circle":
              LayoutManager.circle(x, y);
              break;
          case "keyTap":
              LayoutManager.keyTap(x, y);
              break;
          case "screenTap":
              LayoutManager.tap(x, y);
          case "swipe":
              LayoutManager.swipe(x, y);
              break;
        }
    });
}).use('screenPosition', {scale: 0.5});