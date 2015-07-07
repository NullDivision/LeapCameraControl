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
var TT = null;
var eventsHistory = [];
var marginTop = 0;
var rightHand;
var leftHand;
Leap.loop(options, function (frame) {
    var leap = this;
    if(frame.hands.length == 0){
        LayoutManager.release(x, y, false);
    }
    if(frame.hands.length==2 && eventsHistory.length<2) {
        
        x1 = frame.hands[0].palmPosition[0];
        x2 = frame.hands[1].palmPosition[0];
        distance = getDistance(x1, x2);
        if(eventsHistory.length< 2 && distance > 250 && eventsHistory.indexOf(100) == -1) {
            eventsHistory.push(100);
        }
        
        if(eventsHistory.length< 2 && distance < 120 && eventsHistory.indexOf(100) != -1) {
            eventsHistory.push(50);
        }
        
        
        
        if(eventsHistory.length< 2 && distance < 120 && eventsHistory.indexOf(50) == -1) {
            eventsHistory.push(50);
        }
        
        if(eventsHistory.length < 2 && distance > 250 && eventsHistory.indexOf(50) != -1) {
            eventsHistory.push(100);
        }

        if(eventsHistory.length >= 2)
        {
            if(TT){
                clearTimeout(TT);
            }
            TT = setTimeout(function(){
            
            if(eventsHistory[0]> eventsHistory[1]){
                LayoutManager.zoomOut(socket);
            } else {
                LayoutManager.zoomIn(socket);
            }
            eventsHistory = []},100);
        }
    }
    
    for (var i = 0, len = frame.hands.length; i < len; i++) {
        hand = frame.hands[i];
        var normalized = frame.interactionBox.normalizePoint(hand.palmPosition);
        var x = window.innerWidth * normalized[0];
        var y = window.innerHeight * (1 - normalized[1])+marginTop;
        var z = normalized[2];
        $('.open-hand').css({
            left: x,
            top: y
        });
        if(hand.confidence > 0.4){
            if (hand.grabStrength >= 0.7) {
                LayoutManager.grab(x, y);
                $(".open-hand").hide();
            } else {
                LayoutManager.release(x, y, true);
                $('.open-hand').show();
            }
        }
        LayoutManager.move(x, y);
        LayoutManager.pull(computeZ(z));
    }
    frame.gestures.forEach(function(gesture){

        switch (gesture.type){
          case "keyTap":
              LayoutManager.keyTap(x, y);
              break;
          case "screenTap":
              LayoutManager.tap(x, y);
          case "swipe":
              var isHorizontal = Math.abs(gesture.direction[0]) > Math.abs(gesture.direction[1]);
              if (frame.hands.length == 1) {
                if(isHorizontal) {
                  if(gesture.direction[0] > 0){
                      LayoutManager.flashOn();
                  } else {
                      LayoutManager.flashOff();
                  }  
                }
              }
              break;
        }
    });
}).use('screenPosition', {scale: 0.5});


function getDistance(x1, x2){
    min = Math.max(x1,x2);
    max = Math.min(x1,x2);
    var distance;
    if(min<0 && max< 0){
        distance = Math.abs(min-max);
    } else if(min <0 && max >=0){
        distance = Math.abs(max-min);
    } else {
        distance = Math.abs(max-min);
    }
    return distance;
}

//STREAMING

function init() {
  var host = "ws://192.168.222.31:443/echobot"; // SET THIS TO YOUR SERVER
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