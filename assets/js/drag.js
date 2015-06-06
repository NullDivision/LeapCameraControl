var options = {enableGestures: true};



LayoutManager = {
  release:function(x,y){
    console.log('release');
    $('.hand').hide();
    $('.circle').show();

  },
  grab:function(x,y){
    console.log('grabbed');
    $('.hand').show().css({top:y+'px',left:x+'px',position:'absolute'});
    $('.circle').hide();
  }
};
var grabbed = false;

var clamp = false;   
var appWidth = window.screen.width;
var appHeight = window.screen.height;
var marginTop = 399;
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

        var pointable = frame.pointables[0];
        var position = pointable.stabilizedTipPosition;
        var normalized = frame.interactionBox.normalizePoint(hand.palmPosition);
        var x = window.innerWidth * normalized[0];
        var y = window.innerHeight * (1 - normalized[1])+marginTop;
        if(hand.confidence > 0.2){
          if (hand.grabStrength >= 0.6) {
            LayoutManager.grab(x, y);
            grabbed = true;
          } else {
            if(grabbed) {
              LayoutManager.release(x, y);
              grabbed = false;
            }
          }
        }
    }
}).use('screenPosition', {scale: 0.5});
