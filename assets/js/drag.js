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

function computeZ(axisZ) {
    if(axisZ > 0)
        axisZ = axisZ/3;

    if(axisZ > 1) {
        axisZ = 1;
    } else if(axisZ < -1) {
        axisZ = -1;
    }
    return axisZ;
}

var marginTop = 0;
var grabbed = false;
Leap.loop(options, function (frame) {
    var leap = this;
    for (var i = 0, len = frame.hands.length; i < len; i++) {
        hand = frame.hands[i];
        var normalized = frame.interactionBox.normalizePoint(hand.palmPosition);
        var x = window.innerWidth * normalized[0];
        var y = window.innerHeight * (1 - normalized[1])+marginTop;
        var z = normalized[2];
        $('.finger1').css({
            left: x,
            top: y
        });
        if(hand.confidence > 0.3){
            if (hand.grabStrength >= 0.7) {
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