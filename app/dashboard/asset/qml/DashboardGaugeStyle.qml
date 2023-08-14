import  QtQuick                 2.2
import  QtQuick.Controls.Styles 1.4

CircularGaugeStyle {
    tickmarkInset:      (toPixels(0.02))
    minorTickmarkInset: (tickmarkInset)
    labelStepSize:      (40)
    labelInset:         (toPixels(0.23))

    property real outerRadius:      ((parent.width - tickmarkInset) / 2)
    property real xCenter:          (outerRadius)
    property real yCenter:          (outerRadius)
    property real needleLength:     (outerRadius - (tickmarkInset * 1.25))
    property real needleTipWidth:   (toPixels(0.02))
    property real needleBaseWidth:  (toPixels(0.01))
    property bool halfGauge:        (false)

    function toPixels(_percentage) {
        return  (_percentage * outerRadius);
    }

    function degToRad(_degrees) {
        return  (_degrees * (Math.PI / 180));
    }

    function radToDeg(_radians) {
        return  (_radians * (180 / Math.PI));
    }

    function paintBackground(_ctx) {
        if  (halfGauge) {
            _ctx.beginPath();
            _ctx.rect(
                0,
                0,
                _ctx.canvas.width,
                _ctx.canvas.height / 2
            );
            _ctx.clip();
        }

        // outline
        var gradient = _ctx.createLinearGradient(xCenter, 0, xCenter, _ctx.canvas.height);
        gradient.addColorStop(0, "rgba(30, 240, 253, 0.6)");
        gradient.addColorStop(1, "rgba(30, 240, 253, 0)");

        _ctx.beginPath();
        _ctx.lineWidth = tickmarkInset / 2;
        _ctx.strokeStyle = gradient;
        _ctx.arc(
            xCenter,  yCenter,
            outerRadius,  outerRadius,
            0,
            Math.PI * 2
        );
        _ctx.stroke();

        // 
        _ctx.beginPath();
        var gradient = _ctx.createRadialGradient(
                            xCenter,  yCenter,
                            0,
                            xCenter,  yCenter,
                            outerRadius*1.5
                        );
        gradient.addColorStop(0,    Qt.rgba(30, 240, 253, 0));
        gradient.addColorStop(0.7,  Qt.rgba(30, 240, 253, 0.13));
        gradient.addColorStop(1,    Qt.rgba(30, 240, 253, 1));
        _ctx.fillStyle = gradient;
        _ctx.arc(
            xCenter,
            yCenter,
            outerRadius,
            outerRadius,
            0,
            Math.PI*2
        );
        _ctx.fill();
    }

    background: Canvas {
        onPaint: {
            var _ctx = getContext("2d");
            _ctx.reset();
            paintBackground(_ctx);
        }

        Text {
            id:                         speedText
            font.pixelSize:             toPixels(0.3)
            text:                       spdInt
            color:                      "white"
            horizontalAlignment:        Text.AlignRight
            anchors.horizontalCenter:   parent.horizontalCenter
            anchors.top:                parent.verticalCenter
            anchors.topMargin:          toPixels(0.1)

            readonly property int spdInt: control.value
        }
        Text {
            text:                       "m/min"
            color:                      "white"
            font.pixelSize:             toPixels(0.09)
            anchors.top:                speedText.bottom
            anchors.horizontalCenter:   parent.horizontalCenter
        }
    }

    function map(value, inMin, inMax, outMin, outMax) {
        return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
    }

    needle: Canvas {
        implicitWidth: outerRadius * 2
        implicitHeight: outerRadius * 2

        onPaint: {
            var _ctx = getContext("2d");
            _ctx.reset();

            var speedAngle = map(control.value, 0, 100, -135, 135);

            // Circle tip (end of needle) position
            var tipX = xCenter;
            var tipY = yCenter;

            // Draw needle tip (circle)
            _ctx.beginPath();
            _ctx.arc(tipX, tipY, needleTipWidth, 0, Math.PI * 2);
            _ctx.fillStyle = "rgb(30, 240, 253)";
            _ctx.fill();

            // Calculate the tail start position
            var tailX = 160;
            var tailY = 624;

            // Draw tail
            var tailWidth = needleBaseWidth;
            _ctx.beginPath();
            _ctx.moveTo(tipX, tipY);
            _ctx.lineTo(tailX, tailY);
            var tailGradient = _ctx.createLinearGradient(tipX, tipY, tailX, tailY);
            tailGradient.addColorStop(0, "rgba(30, 240, 253, 1)");
            tailGradient.addColorStop(0.2, "rgba(30, 240, 253, 0)");
            _ctx.lineWidth = tailWidth;
            _ctx.strokeStyle = tailGradient;
            _ctx.stroke();

        }
    }

    foreground: null
}
