var options = {enableGestures: true};
LayoutManager = {
  release:function(x,y){
    console.log('release');
  },
  grab:function(x,y){
    console.log('grabbed');
  }
};
var x = 0;
function reloadImage(){
    if(!$("#image")[0].complete)
        return;
    x++;
    var url = "http://10.0.0.21:8080/img.jpg?"+x;
    $("#image").attr('src',url);
    console.log('reload');
}
setInterval(reloadImage, 40);
var grabbed = false;
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

    for (var i = 0, len = frame.hands.length; i < len; i++) {
        hand = frame.hands[i];
        var position = hand.screenPosition();
        var pointer = $("#pointer");
        var x = position[0] - pointer.width()  / 2;
        var y = position[1] - pointer.height() / 2;
        if(hand.confidence > .7){
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
}).use('screenPosition', {scale: 0.5});;