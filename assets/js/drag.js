var options = {enableGestures: true};
var socket;
var streams = [];

LayoutManager.swipe = function (x,y){
    console.log("swiped");
};
LayoutManager.tap = function (x,y){
    console.log("tapped");
};
LayoutManager.keyTap = function (x,y){
    console.log("keytap");
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
        LayoutManager.pull(computeZ(z));
    }
    frame.gestures.forEach(function(gesture){
        switch (gesture.type){
          case "circle":
              LayoutManager.circle(x, y, hand.roll(), socket);
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


//STREAMING

function init() {
  var host = "ws://10.0.0.35:9000/echobot"; // SET THIS TO YOUR SERVER
  try {
      socket = new WebSocket(host);
      console.log('WebSocket - status '+socket.readyState);
      socket.onopen    = function(msg) { 
                   console.log("Welcome - status "+this.readyState); 
                 };
      socket.onmessage = function(msg) { 
                  data = JSON.parse(msg.data);
                  if (data) {
                    if (data.cmd == 5) {
                      streams[data.usr] = data.data;
                      render();
                    }
                  }
                  //  console.log("Received: "+msg.data); 
                 };
      socket.onclose   = function(msg) { 
                   console.log("Disconnected - status "+this.readyState); 
                 };
    }
    catch(ex){ 
      console.log(ex); 
    }
  }
function render()
{
  for(var id in streams) {
    var ids = 'stream' + id;
    if($('#'+ids).length) {
        $('#'+ids+" img").attr('src', 'data:image/jpg;base64,'+streams[id]);
    } else {
        var str = '<div class="feed-container"  id="'+ids+'"><img class="feed-img" src="data:image/jpg;base64,'+streams[id]+'" usr="'+id+'"/></div>';
        $('#camera-feeds').append(str);
    }
  }
}

function send(msg){
  if(!msg) { 
    alert("Message can not be empty"); 
    return; 
  }
  try { 
    socket.send(msg); 
    console.log('Sent: '+msg); 
  } catch(ex) { 
    console.log(ex); 
  }
}
$( document ).ready(function() {
  init();
});