import QtQuick 2.2

Item {
    property int direction: Qt.LeftArrow
    property bool on: true
    property bool flashing: true
    property int valueSource: valueSource.indicator  // 예를 들면 이렇게, 실제 valueSource.indicator 값을 어떻게 가져올지에 따라 수정 필요

    scale: direction === Qt.LeftArrow ? 1 : -1

    Timer {
        id: flashTimer
        interval: 500
        running: on
        repeat: true
        onTriggered: flashing = !flashing
    }

    function paintOutlinePath(_ctx) {
        _ctx.beginPath();
        _ctx.moveTo(0, height * 0.5);
        _ctx.lineTo(0.6 * width, 0);
        _ctx.lineTo(0.6 * width, height * 0.28);
        _ctx.lineTo(width, height * 0.28);
        _ctx.lineTo(width, height * 0.72);
        _ctx.lineTo(0.6 * width, height * 0.72);
        _ctx.lineTo(0.6 * width, height);
        _ctx.lineTo(0, height * 0.5);
    }

    Canvas {
        id: backgroundCanvas
        anchors.fill: parent

        onPaint: {
            var _ctx = getContext("2d");
            _ctx.reset();

            paintOutlinePath(_ctx);

            _ctx.lineWidth = 1;
            _ctx.strokeStyle = "black";
            _ctx.stroke();
        }
    }

    Canvas {
        id: foregroundCanvas
        anchors.fill: parent
        visible: on && flashing

        onPaint: {
            var _ctx = getContext("2d");
            _ctx.reset();

            paintOutlinePath(_ctx);

            // 색상을 valueSource.indicator 값에 따라 설정합니다.
            if (valueSource.indicator === -1 && direction === Qt.LeftArrow) {
                _ctx.fillStyle = "#1EF0FD";
            } else if (valueSource.indicator === 1 && direction !== Qt.LeftArrow) {
                _ctx.fillStyle = "#1EF0FD";
            } else {
                _ctx.fillStyle = "gray";
            }

            _ctx.fill();
        }
    }
}
