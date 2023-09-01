import  QtQuick                 2.2
import  QtQuick.Controls.Styles 1.4
import  QtGraphicalEffects      1.0


CircularGaugeStyle {

    //  ========================================================================
    //  Variables
    //  - For calculations
    tickmarkInset:      (toPixels(0.02))
    minorTickmarkInset: (tickmarkInset)
    labelInset:         (toPixels(0.23))

    property real   outerRadius:        ((parent.width - tickmarkInset) / 2 - 1)
    property real   xCenter:            (outerRadius + 2)
    property real   yCenter:            (outerRadius + 2)
    property real   needleLength:       (outerRadius - (tickmarkInset * 1.25))
    property real   needleTipWidth:     (toPixels(0.03))
    property real   needleBaseWidth:    (toPixels(0.01))
    property real   tailX:              (0)
    property real   tailY:              (0)

    //  - For Main Text/Labels
    property string mainLabel:          ("")
    property real   mainFontSize:       (0)
    property real   labelSteps:         (5)
    property real   maximumValue:       (60)

    //  - For indicators
    property real   indicator:          (valueSource.indicator)
    property bool   isIndicatorOn:      (true)

    //  - For gear
    property string gear:               (valueSource.gear)
    property bool   isGearOn:           (true)

    //  - For needle
    // property real   angle:              (-235 + (290 * (value - minimumValue) / (maximumValue - minimumValue)))
    //  Variables End
    //  ========================================================================


    //  ========================================================================
    //  Calculate
    function toPixels(_percentage) {
        return  (_percentage * outerRadius); }
    function degToRad(_degrees) {
        return  (_degrees * (Math.PI / 180)); }
    function radToDeg(_radians) {
        return  (_radians * (180 / Math.PI)); }
    function map(value, inMin, inMax, outMin, outMax) {
        return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin; }
    //  Calculate End
    //  ========================================================================


    //  ========================================================================
    //  Background function
    function paintBackground(_ctx) {
        // outline
        var gradient = _ctx.createLinearGradient(xCenter, 0, xCenter, _ctx.canvas.height);
        gradient.addColorStop(0,   "rgba(30, 240, 253, 0.8)");
        gradient.addColorStop(0.5, "rgba(30, 240, 253, 0.7)");
        gradient.addColorStop(0.9, "rgba(30, 240, 253, 0)");

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
        var gradient = _ctx.createLinearGradient(
                            xCenter,  0,
                            xCenter,  _ctx.canvas.height
                        );
        gradient.addColorStop(0,   "rgba(3, 240, 253, 0.1)");
        gradient.addColorStop(0.7, "rgba(3, 240, 253, 0.05)");
        gradient.addColorStop(0.9, "rgba(3, 240, 253, 0.0)");
        _ctx.fillStyle = gradient;
        _ctx.arc(
            xCenter,
            yCenter,
            outerRadius,
            0,          // start angle
            Math.PI * 2 // end angle
        );
        _ctx.fill();
    }
    //  Background function End
    //  ========================================================================


    //  ========================================================================
    //  Background, Main, Indicator, Gear
    background: Canvas {
        //  ====================================================================
        //  main Text/Label Container
        Item {
            id:                 mainTextContainer
            anchors.centerIn:   (parent)
            width:              (mainText.width)
            height:             (mainText.height + labelText.height)

            //  ================================================================
            //  main Text
            Text {
                id:                         mainText
                font.pixelSize:             (mainFontSize)
                text:                       (spdInt)
                color:                      ("white")
                horizontalAlignment:        (Text.AlignHCenter)
                anchors.horizontalCenter:   (parent.horizontalCenter)
                verticalAlignment:          (Text.AlignVCenter)

                readonly property int spdInt: (control.value)

                layer.enabled:              (true)
                layer.effect: DropShadow {
                    color:      Qt.rgba(255, 255, 255, 0.1)
                    radius:     10
                    spread:     0.5
                    samples:    16
                    source:     mainText
                }
            }
            //  Main Text End
            //  ================================================================

            //  ================================================================
            //  Main Label
            Text {
                id:                         labelText
                text:                       (mainLabel)
                color:                      ("#696969")
                font.pixelSize:             (12)
                anchors.top:                (mainText.bottom)
                anchors.topMargin:          (-toPixels(0.1))
                anchors.horizontalCenter:   (parent.horizontalCenter)
            }
            //  Main Label End
            //  ================================================================
        }
        //  Text/Label Container End
        //  ====================================================================

        //  ====================================================================
        //  Gauge Number Label
        Repeater {
            model: Math.ceil(control.maximumValue / labelSteps) + 1  // Calculate how many labels will be needed

            Text {
                font.pixelSize: labelSize
                color: labelColor
                text: labelText
                font.italic: true

                property int value: index * labelSteps
                property real angle: map(value, 0, control.maximumValue, -235, 55)  // Use control.maximumValue instead of 60
                property string labelText: String(value)
                property real labelSize: value % (2 * labelSteps) === 0 ? toPixels(0.08) : toPixels(0.07)  // Change the condition to be dynamic based on labelSteps
                property color labelColor: value % (2 * labelSteps) === 0 ? "#E0E0E0" : "#696969"  // Change the condition to be dynamic based on labelSteps
                property real labelDistance: outerRadius - toPixels(0.1)

                x: parent.width / 2 + Math.cos(degToRad(angle)) * labelDistance - width / 2
                y: parent.height / 2 + Math.sin(degToRad(angle)) * labelDistance - height / 2
            }
        }
        //  Gauge Number Label End
        //  ====================================================================

        //  ====================================================================
        //  Turn Indicator
        Timer {
            id: blinkTimer
            interval: 500
            running: indicator === 3
            repeat: true
            onTriggered: {
                if(blinkState === "on")
                    blinkState = "off";
                else
                    blinkState = "on";
            }
        }
        property string blinkState: ("off")

        /*
        onIndicatorChanged: {
            if(indicator === 3) {
                blinkTimer.start();
            } else {
                blinkTimer.stop();
                blinkState = false;  // Make sure blinkState is reset when indicator is not 3.
            }
        }
        */

        Component.onCompleted: {
            if (indicator === 3) {
                blinkTimer.start();
            }
        }
        function drawIndicatorArrow(_ctx, x, y, rotationAngle, active) {
            _ctx.save();
            _ctx.translate(x, y);
            _ctx.rotate(degToRad(rotationAngle));

            // Draw the base triangle first
            _ctx.beginPath();
            _ctx.moveTo(40, -10);
            _ctx.lineTo(55, 0);
            _ctx.lineTo(40, 10);
            _ctx.closePath();

            if (active) {
                _ctx.fillStyle = "#1EF0FD";
            } else {
                _ctx.fillStyle = "#525252";
            }
            _ctx.fill();

            if (active) {
                // Add outer glow
                var gradient = _ctx.createRadialGradient(47.5, 0, 5, 47.5, 0, 30);
                gradient.addColorStop(0,   "rgba(3, 240, 253, 0.1)");
                gradient.addColorStop(0.5, "rgba(3, 240, 253, 0.01)");
                gradient.addColorStop(0.7, "rgba(3, 240, 253, 0)");

                // Using shadow as a trick to add blur to the radial gradient
                _ctx.shadowColor = "#1EF0FD";
                _ctx.shadowBlur = 10;  // Adjust this value to increase or decrease the blur intensity
                _ctx.shadowOffsetX = 0;
                _ctx.shadowOffsetY = 0;

                _ctx.fillStyle = gradient;
                _ctx.beginPath();
                _ctx.arc(47.5, 0, 30, 0, 2 * Math.PI, false);
                _ctx.fill();
            }

            _ctx.restore();
        }
        //  Turn Indicator End
        //  ====================================================================

        //  ====================================================================
        //  Gear Drawing
        function drawGearButton(_ctx, x, y, gearLabel, isActive) {
            // Define colors based on active state
            const textColor     = isActive ? "rgba(255,255,255,1)" : "rgba(255,255,255,0.6)";
            const boxColor      = isActive ? "rgba(227,227,227,0.15)" : "rgba(227,227,227,0.1)";
            const boxWidth      = 20;
            const boxHeight     = 30;
            const borderThick   = 0.6;
            const borderColor   = "rgba(255,255,255,1)";

            // Clip the outer area to draw the outer glow effect
            _ctx.save();
            _ctx.beginPath();
            _ctx.rect(x - boxWidth, y - boxHeight, boxWidth * 3, boxHeight * 3);
            _ctx.rect(x, y, boxWidth, boxHeight);
            _ctx.clip("evenodd");

            if (isActive) {
                // Outer glow effect for active gear
                var gradient = _ctx.createRadialGradient(x + boxWidth / 2, y + boxHeight / 2, 0, x + boxWidth / 2, y + boxHeight / 2, boxWidth * 1.5);
                gradient.addColorStop(0,   "rgba(255, 255, 255, 0.2)");
                gradient.addColorStop(0.8, "rgba(255, 255, 255, 0.05)");
                gradient.addColorStop(1,   "rgba(255, 255, 255, 0.0)");

                _ctx.fillStyle = gradient;
                _ctx.fillRect(x - boxWidth, y - boxHeight, boxWidth * 3, boxHeight * 3);
            }

            _ctx.restore();

            // Draw background box
            _ctx.beginPath();
            _ctx.rect(x, y, boxWidth, boxHeight);
            _ctx.fillStyle = boxColor;
            _ctx.fill();

            // Draw box border
            if (isActive) {
                var borderGradient = _ctx.createLinearGradient(x, y, x, y + boxHeight);
                borderGradient.addColorStop(0,   "rgba(255,255,255,0.9)");
                borderGradient.addColorStop(0.7, "rgba(255,255,255,0.7)");
                borderGradient.addColorStop(1,   "rgba(255,255,255,0)");

                _ctx.strokeStyle = borderGradient;
                _ctx.lineWidth = borderThick;
                _ctx.strokeRect(x, y, boxWidth, boxHeight);
            }

            // Draw gear text
            _ctx.font = "13px Futura Bold"; // Adjusted font here
            _ctx.fillStyle = textColor;
            _ctx.textAlign = "center";
            _ctx.textBaseline = "middle";
            _ctx.fillText(gearLabel, x + boxWidth / 2, y + boxHeight / 2);
        }
        //  ====================================================================
        //  Gear Drawing End

        //  ====================================================================
        //  Rendering
        onPaint: {
            var _ctx = getContext("2d");
            _ctx.reset();

            //  drawing background
            paintBackground(_ctx);

            //  drawing indicator
            if (isIndicatorOn === true) {
                if (indicator === 1 || (indicator === 3 && blinkState))
                    drawIndicatorArrow(_ctx, xCenter - 40, yCenter, 180, true);
                else
                    drawIndicatorArrow(_ctx, xCenter - 40, yCenter, 180, false);

                if (indicator === 2 || (indicator === 3 && blinkState))
                    drawIndicatorArrow(_ctx, xCenter + 40, yCenter, 0, true);
                else
                    drawIndicatorArrow(_ctx, xCenter + 40, yCenter, 0, false);
            }

            //  drawing gear
            if (isGearOn === true) {
                drawGearButton(_ctx, xCenter - 55, yCenter + 130, "P", gear === "P");
                drawGearButton(_ctx, xCenter - 10, yCenter + 130, "D", gear === "D");
                drawGearButton(_ctx, xCenter + 35, yCenter + 130, "R", gear === "R");
            }
        }
        //  Rendering end
        //  ====================================================================
    }
    //  Background, Main, Indicator, Gear End
    //  ========================================================================


    //  ========================================================================
    //  Needle
    needle: Canvas {
        implicitWidth: outerRadius * 2
        implicitHeight: outerRadius * 2

        onPaint: {
            var _ctx = getContext("2d");
            _ctx.reset();

            var speedAngle = speedometer.ndlAngle;

            // Circle tip (end of needle) position
            var tipX = xCenter;
            var tipY = yCenter;

            // Draw needle tip (circle)
            _ctx.beginPath();
            _ctx.arc(tipX, tipY, needleTipWidth, 0, Math.PI * 2);
            _ctx.fillStyle = "rgba(30, 240, 253, 1)";
            _ctx.fill();

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
    //  Needle End
    //  ========================================================================


    //  ========================================================================
    //  Options
    foreground: null
    //  Options End
    //  ========================================================================
}
