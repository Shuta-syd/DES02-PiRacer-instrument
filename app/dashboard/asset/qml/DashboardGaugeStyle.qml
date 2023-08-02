import  QtQuick                 2.2
import  QtQuick.Controls.Styles 1.4

CircularGaugeStyle {
    tickmarkInset:      (toPixels(0.04))
    minorTickmarkInset: (tickmarkInset)
    labelStepSize:      (40)
    labelInset:         (toPixels(0.23))

    property real xCenter:          (outerRadius)
    property real yCenter:          (outerRadius)
    property real needleLength:     (outerRadius - (tickmarkInset * 1.25))
    property real needleTipWidth:   (toPixels(0.02))
    property real needleBaseWidth:  (toPixels(0.06))
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
                0,  0,
                _ctx.canvas.width,  _ctx.canvas.height/2
            );
            _ctx.clip();
        }

        _ctx.beginPath();
        _ctx.fillStyle = "black";
        _ctx.ellipse(
            0,  0,
            _ctx.canvas.width,  _ctx.canvas.height
        );
        _ctx.fill();

        _ctx.beginPath();
        _ctx.lineWidth = tickmarkInset;
        _ctx.strokeStyle = "black";
        _ctx.arc(
            xCenter,  yCenter,
            outerRadius - _ctx.lineWidth/2,  outerRadius - _ctx.lineWidth/2,
            0,
            Math.PI * 2
        );
        _ctx.stroke();

        _ctx.beginPath();
        _ctx.lineWidth = tickmarkInset / 2;
        _ctx.strokeStyle = "#222";
        _ctx.arc(
            xCenter,  yCenter,
            outerRadius - _ctx.lineWidth/2,  outerRadius - _ctx.lineWidth/2,
            0,
            Math.PI * 2
        );
        _ctx.stroke();

        _ctx.beginPath();
        var gradient = _ctx.createRadialGradient(
                            xCenter,  yCenter,
                            0,
                            xCenter,  yCenter,
                            outerRadius*1.5
                        );
        gradient.addColorStop(0,    Qt.rgba(1, 1, 1, 0));
        gradient.addColorStop(0.7,  Qt.rgba(1, 1, 1, 0.13));
        gradient.addColorStop(1,    Qt.rgba(1, 1, 1, 1));
        _ctx.fillStyle = gradient;
        _ctx.arc(
            xCenter,  yCenter,
            outerRadius - tickmarkInset,
            outerRadius - tickmarkInset,
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
            text:                       kphInt
            color:                      "white"
            horizontalAlignment:        Text.AlignRight
            anchors.horizontalCenter:   parent.horizontalCenter
            anchors.top:                parent.verticalCenter
            anchors.topMargin:          toPixels(0.1)

            readonly property int kphInt: control.value
        }
        Text {
            text:                       "cm/s"
            color:                      "white"
            font.pixelSize:             toPixels(0.09)
            anchors.top:                speedText.bottom
            anchors.horizontalCenter:   parent.horizontalCenter
        }
    }

    needle: Canvas {
        implicitWidth:  needleBaseWidth
        implicitHeight: needleLength

        property real xCenter: width / 2
        property real yCenter: height / 2

        onPaint: {
            var _ctx = getContext("2d");
            _ctx.reset();

            _ctx.beginPath();
            _ctx.moveTo(xCenter,  height);
            _ctx.lineTo(xCenter - needleBaseWidth/2,  height - needleBaseWidth/2);
            _ctx.lineTo(xCenter - needleTipWidth/2,  0);
            _ctx.lineTo(xCenter,  yCenter - needleLength);
            _ctx.lineTo(xCenter,  0);
            _ctx.closePath();
            _ctx.fillStyle = Qt.rgba(0.66, 0, 0, 0.66);
            _ctx.fill();

            _ctx.beginPath();
            _ctx.moveTo(xCenter,  height)
            _ctx.lineTo(width,  height - needleBaseWidth/2);
            _ctx.lineTo(xCenter + needleTipWidth/2, 0);
            _ctx.lineTo(xCenter, 0);
            _ctx.closePath();
            _ctx.fillStyle = Qt.lighter(Qt.rgba(0.66, 0, 0, 0.66));
            _ctx.fill();
        }
    }

    foreground: null
}
