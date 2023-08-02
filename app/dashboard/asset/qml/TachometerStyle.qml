import  QtQuick                 2.2
import  QtQuick.Controls.Styles 1.4
import  QtQuick.Extras          1.4

DashboardGaugeStyle {
    id:                 tachometerStyle
    tickmarkStepSize:   (1)
    labelStepSize:      (1)
    needleLength:       (toPixels(0.85))
    needleBaseWidth:    (toPixels(0.08))
    needleTipWidth:     (toPixels(0.03))

    tickmark: Rectangle {
        implicitWidth:      (toPixels(0.03))
        antialiasing:       (true)
        implicitHeight:     (toPixels(0.08))
        color:              (styleData.index === 7) ||
                            (styleData.index === 8) ? Qt.rgba(0.5, 0, 0, 1) : "#c8c8c8"
    }

    minorTickmark:      (null)

    tickmarkLabel: Text {
        font.pixelSize:     (Math.max(6, toPixels(0.12)))
        text:               (styleData.value)
        color:              (styleData.index === 7) ||
                            (styleData.index === 8) ? Qt.rgba(0.5, 0, 0, 1) : "#c8c8c8"
        antialiasing:       (true)
    }

    background: Canvas {
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            paintBackground(ctx);

            ctx.beginPath();
            ctx.lineWidth = tachometerStyle.toPixels(0.08);
            ctx.strokeStyle = Qt.rgba(0.5, 0, 0, 1);
            var warningCircumference = maximumValueAngle - minimumValueAngle * 0.1;
            var startAngle = maximumValueAngle - 90;
            ctx.arc(outerRadius, outerRadius,
                // Start the line in from the decorations, and account for the width of the line itself.
                outerRadius - tickmarkInset - ctx.lineWidth / 2,
                degToRad(startAngle - angleRange / 8 + angleRange * 0.015),
                degToRad(startAngle - angleRange * 0.015), false);
            ctx.stroke();
        }

        Text {
            id:                         rpmText
            font.pixelSize:             (tachometerStyle.toPixels(0.3))
            text:                       (rpmInt)
            color:                      ("white")
            horizontalAlignment:        (Text.AlignRight)
            anchors.horizontalCenter:   (parent.horizontalCenter)
            anchors.top:                (parent.verticalCenter)
            anchors.topMargin:          (20)

            readonly property int rpmInt: valueSource.rpm
        }

        Text {
            text:                       ("x1000")
            color:                      ("white")
            font.pixelSize:             (tachometerStyle.toPixels(0.1))
            anchors.top:                (parent.top)
            anchors.topMargin:          (parent.height / 4)
            anchors.horizontalCenter:   (parent.horizontalCenter)
        }
        Text {
            text:                       ("RPM")
            color:                      ("white")
            font.pixelSize:             (tachometerStyle.toPixels(0.1))
            anchors.top:                (rpmText.bottom)
            anchors.horizontalCenter:   (parent.horizontalCenter)
        }
    }
}
