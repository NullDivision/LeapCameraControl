require(
    ['LayoutManager', 'Leap', 'jQuery', 'WebSocket'],
    function (LayoutManager, Leap, $, WebSocket) {
        'use strict';

        var socket,
            options       = {enableGestures: true},
            streams       = [],
            TT            = null,
            eventsHistory = [],
            marginTop     = 0;

        function computeZ(axisZ) {
            if (axisZ > 0) {
                axisZ = axisZ / 3;
            } else if (axisZ > 1) {
                axisZ = 1;
            } else if (axisZ < -1) {
                axisZ = -1;
            }

            return axisZ;
        }

        function getDistance(x1, x2) {
            var distance,
                min = Math.max(x1, x2),
                max = Math.min(x1, x2);

            if (min < 0 && max < 0) {
                distance = Math.abs(min - max);
            } else if (min < 0 && max >= 0) {
                distance = Math.abs(max - min);
            } else {
                distance = Math.abs(max - min);
            }
            return distance;
        }

        function renderStream(id, stream) {
            var str,
                ids = 'stream' + id,
                streamSrc = 'data:image/jpg;base64,' + stream;

            if ($('#' + ids).length) {
                $('#' + ids + " img").attr('src', streamSrc);
            } else {
                str = '<img class="feed-img" src="' + streamSrc + '" usr="' + id + '"/>';
                str = '<div class="feed-container" id="' + ids + '">' + str + '</div>';
                $('#camera-feeds').append(str);
            }
        }

        function render() {
            var i, id,
                streamIds = Object.keys(streams);

            for (i = streamIds.length - 1; i >= 0; i--) {
                id = streamIds[i];
                renderStream(id, streams[id]);
            }
        }

        Leap.loop(options, function (frame) {
            var distance, hand, i, len, normalized, x, y, z;

            if (!frame.hands.length) {
                LayoutManager.release(x, y, false);
            }

            if (2 === frame.hands.length && eventsHistory.length < 2) {
                distance = getDistance(
                    frame.hands[0].palmPosition[0],
                    frame.hands[1].palmPosition[0]
                );

                if (eventsHistory.length < 2) {
                    if (distance > 250) {
                        if (eventsHistory.indexOf(100) === -1) {
                            eventsHistory.push(100);
                        }

                        if (eventsHistory.indexOf(50) !== -1) {
                            eventsHistory.push(100);
                        }
                    }

                    if (distance < 120) {
                        if (eventsHistory.indexOf(100) !== -1) {
                            eventsHistory.push(50);
                        }

                        if (eventsHistory.indexOf(50) === -1) {
                            eventsHistory.push(50);
                        }
                    }
                }

                if (eventsHistory.length >= 2) {
                    if (TT) {
                        clearTimeout(TT);
                    }

                    TT = setTimeout(function () {
                        if (eventsHistory[0] > eventsHistory[1]) {
                            LayoutManager.zoomOut(socket);
                        } else {
                            LayoutManager.zoomIn(socket);
                        }

                        eventsHistory = [];
                    }, 100);
                }
            }

            for (i = 0, len = frame.hands.length; i < len; i++) {
                hand       = frame.hands[i];
                normalized = frame.interactionBox.normalizePoint(hand.palmPosition);

                x = window.innerWidth * normalized[0];
                y = window.innerHeight * (1 - normalized[1]) + marginTop;
                z = normalized[2];

                $('.open-hand').css({
                    left: x,
                    top: y
                });

                if (hand.confidence > 0.4) {
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

            frame.gestures.forEach(function (gesture) {
                switch (gesture.type) {
                case "keyTap":
                    LayoutManager.keyTap(x, y);
                    break;
                case "screenTap":
                    LayoutManager.tap(x, y);
                    break;
                case "swipe":
                    var isHorizontal = Math.abs(gesture.direction[0]) > Math.abs(gesture.direction[1]);

                    if (frame.hands.length === 1) {
                        if (isHorizontal) {
                            if (gesture.direction[0] > 0) {
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

        //STREAMING

        function init() {
            var host = "ws://192.168.222.31:443/echobot"; // SET THIS TO YOUR SERVER

            try {
                socket = new WebSocket(host);

                socket.onmessage = function (msg) {
                    var data = JSON.parse(msg.data);
                    if (data) {
                        if (5 === data.cmd) {
                            streams[data.usr] = data.data;
                            render();
                        }
                    }
                };
            } catch (ex) {
                console.log(ex);
            }
        }

        function send(msg) {
            if (!msg) {
                alert("Message can not be empty");
                return;
            }

            try {
                socket.send(msg);
            } catch (ex) {
                console.log(ex);
            }
        }

        $(document).ready(function () {
            init();
        });
    }
);
