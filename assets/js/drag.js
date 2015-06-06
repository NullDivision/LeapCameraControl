var options = {enableGestures: true};



LayoutManager = {
  grabbed: false,
  release:function(x,y){
    console.log('release');
    $('.hand').hide();
    $('.circle').show();
    this.grabbed = false;
  },
  grab:function(x,y){
    console.log('grabbed');
    $('.hand').show().css({top:y+'px',left:x+'px',position:'absolute'});
    $('.circle').hide();
    this.grabbed = true;
  },
  pull: function(x, y, z){
    console.log("pulled:"+x+","+y+","+z);
  },
  swipe: function (x,y){
    console.log("swiped");
  },
  tap: function (x,y){
    console.log("tapped");
  },
  keyTap: function (x,y){
    console.log("keytap");
  },
  circle: function (x,y){
    console.log("circle");
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
//setInterval(reloadImage, 40);
 
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
        var normalized = frame.interactionBox.normalizePoint(hand.palmPosition);
        var x = window.innerWidth * normalized[0];
        var y = window.innerHeight * (1 - normalized[1])+marginTop;
        var z = normalized[2];
        if(hand.confidence > 0.2){
          if (hand.grabStrength >= 0.6) {
            LayoutManager.grab(x, y);
          } else {
            if(LayoutManager.grabbed) {
              LayoutManager.release(x, y);
            }
          }
        }
        if (z >= 1) {
            if(LayoutManager.grabbed){
                LayoutManager.pull(x, y, z);
            }      
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
