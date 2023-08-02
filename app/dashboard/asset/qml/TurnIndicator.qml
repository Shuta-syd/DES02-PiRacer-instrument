//import  QtQuick 2.2

//Item {
//    // This enum is actually keyboard-related, but it serves its purpose
//    // as an indication of direction for us.
//    property int    direction:  (Qt.LeftArrow)
//    property bool   on:         (false)
//    property bool   flashing:   (false)

//    scale:          (direction === Qt.LeftArrow ? 1 : -1)

////! [1]
//    Timer {
//        id:             flashTimer
//        interval:       (500)
//        running:        (on)
//        repeat:         (true)
//        onTriggered:    (flashing = !flashing)
//    }
////! [1]

////! [2]
//    function paintOutlinePath(_ctx) {
//        _ctx.beginPath();
//        _ctx.moveTo(0, height * 0.5);
//        _ctx.lineTo(0.6 * width, 0);
//        _ctx.lineTo(0.6 * width, height * 0.28);
//        _ctx.lineTo(width, height * 0.28);
//        _ctx.lineTo(width, height * 0.72);
//        _ctx.lineTo(0.6 * width, height * 0.72);
//        _ctx.lineTo(0.6 * width, height);
//        _ctx.lineTo(0, height * 0.5);
//    }
////! [2]

//    Canvas {
//        id:             backgroundCanvas
//        anchors.fill:   (parent)

//        onPaint: {
//            var _ctx = getContext("2d");
//            _ctx.reset();

//            paintOutlinePath(_ctx);

//            _ctx.lineWidth = 1;
//            _ctx.strokeStyle = "black";
//            _ctx.stroke();
//        }
//    }

////! [3]
//    Canvas {
//        id:             foregroundCanvas
//        anchors.fill:   (parent)
//        visible:        (on && flashing)

//        onPaint: {
//            var _ctx = getContext("2d");
//            _ctx.reset();

//            paintOutlinePath(_ctx);

//            _ctx.fillStyle = "green";
//            _ctx.fill();
//        }
//    }
////! [3]

//}
