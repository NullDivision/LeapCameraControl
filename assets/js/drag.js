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


Leap.loop(options, function (frame) {
    var leap = this;
    
    
    
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
    for (var i = 0, len = frame.hands.length; i < len; i++) {
        hand = frame.hands[i];
        var iBox = leap.frame().interactionBox;
        var pointable = leap.frame().pointables[0];
        var leapPoint = pointable.stabilizedTipPosition;
        var position = differentialNormalizer(leapPoint, iBox, hand.isLeft, clamp);
        console.log(position);
        var x = position.x;
        var y = position.y;
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





function differentialNormalizer(leapPoint, iBox, isLeft, clamp)
{
    var normalized = iBox.normalizePoint(leapPoint, false);
    var offset = isLeft ? 0.25 : -0.25;
    normalized.x += offset;

    //clamp after offsetting
    normalized.x = (clamp && normalized.x < 0) ? 0 : normalized.x;
    normalized.x = (clamp && normalized.x > 1) ? 1 : normalized.x;
    normalized.y = (clamp && normalized.y < 0) ? 0 : normalized.y;
    normalized.y = (clamp && normalized.y > 1) ? 1 : normalized.y;

    return normalized;
}