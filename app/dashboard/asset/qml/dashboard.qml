import  QtQuick                 2.2
import  QtQuick.Window          2.1
import  QtQuick.Controls        1.4
import  QtQuick.Controls.Styles 1.4
import  QtQuick.Extras          1.4
import  QtGraphicalEffects      1.0
import  "."

Window {
    id:             root
    title:          "dashboard"
    visible:        (true)
    width:          (1250)
    height:         (400)
    minimumWidth:   (400)
    minimumHeight:  (300)
    color:          ("#000000")

    ValueSource {
        id:     valueSource
    }

    //  ========================================================================
    //  Top Navbar
    Item {
        id:     navbarContainer
        width:  (root.width)
        height: (30)

        
        // battery icon
        Item { 
            id:                 batteryIcon
            width:              (35)
            height:             (13)
            anchors.top:        (parent.top)
            anchors.left:       (parent.left)
            anchors.leftMargin: (200)
            anchors.topMargin:  (12)

            layer.enabled:      (true)
            layer.effect:       Glow {
                radius:             (2)
                color:              Qt.rgba(30, 240, 253, 0.6)
                spread:             (0.1)
            }

            // Outer Rectangle (Battery Outline)
            Rectangle {
                id:                 batteryOutline
                width:              (parent.width)
                height:             (parent.height)
                border.color:       ("#1EF0FD")
                border.width:       (1)
                color:              ("transparent")
                radius:             (2)
            }

            // Inner Rectangle (Battery Level)
            Rectangle {
                id:                 batteryLevel
                width:              (batteryOutline.width * (((valueSource.level > 100) ? 100 : valueSource.level) / 100))
                height:             (batteryOutline.height - 2)
                anchors {
                    verticalCenter: (batteryOutline.verticalCenter)
                    left:           (batteryOutline.left)
                }
                color:              ("#1EF0FD")
            }
        }

        // Battery percentage and estimated time
        Item {
            id:                     batteryInfo
            anchors.left:           (batteryIcon.right)
            anchors.top:            (parent.top)
            anchors.verticalCenter: (batteryIcon.verticalCenter)
            anchors.topMargin:      (7)
            anchors.leftMargin:     (15)

            Text {
                text:               (parseInt(Math.min(valueSource.level, 100)) + "%  "  + parseInt(valueSource.left_hour) + " hours" + "\n" 
                                        + parseInt(valueSource.voltage) + " V " + " " + parseInt(valueSource.current) + " mA" )
                font.pixelSize:     (18)
                color:              ("white")
            }
        }

        Item { 
            anchors.top:        (parent.top)
            anchors.right:      (parent.right)
            anchors.rightMargin:60
            anchors.topMargin:  10

            Text {
                id:                 timeText
                font.pixelSize:     18
                color:              (Qt.rgba(1,1,1,1))
                text:               (valueSource.time)

                layer.effect: Glow { // shading effect
                    radius:             10
                    samples:            16
                    color:              (Qt.rgba(1,1,1,1))
                    source:             timeText
                }
            }
        }
    }

    //  ========================================================================
    //  Content Container
    Item {
        id:               container
        width:            (root.width)
        height:           (Math.min(root.width, root.height))

        Row {
            id:               gaugeRow
            spacing:          (container.width * 0.02)
            anchors.centerIn: (parent)

            
            //  ================================================================
            //  Consumption
            Item {
                id:                     consumptionContainer
                width:                  (height * 0.75)
                height:                 (container.height * 0.75)
                anchors.verticalCenter: (root.verticalCenter)
                property int padding:   (20)


                CircularGauge {
                    id:                     consumption
                    width:                  (parent.width)
                    height:                 (parent.height)
                    z:                      (1)

                    value:                  (valueSource.consumption)
                    maximumValue:           (50)
                    tickmarksVisible:       (false)
                    //property real ndlAngle: (map(valueSource.speed, 0, 100, -135, 135))

                    anchors {
                        top:                (parent.top)
                        left:               (parent.left)
                        margins:            (consumptionContainer.padding)
                        topMargin:          (consumptionContainer.padding + 80)
                        leftMargin:         (0)
                        rightMargin:        (0)
                    }

                    style: DashboardGaugeStyle {
                        isIndicatorOn:      (false)
                        isGearOn:           (false)
                        tailX:              (145)
                        tailY:              (624)
                        mainLabel:          ("Power Consumption (W)")
                        mainFontSize:       (toPixels(0.45))
                        labelSteps:         (5)
                    }

                    NumberAnimation {
                        //target: consumption
                        //property: "ndlAngle"
                        target: needle
                        //to: map(valueSource.consumption, 0, 100, -135, 135)
                        easing.type: Easing.InOutQuad
                        duration: 60
                    }
                }
            }
            //  Consumption End
            //  ================================================================


            //  ================================================================
            //  Speedometer
            Item {
                id:                     speedometerContainer
                width:                  (height)
                height:                 (container.height)
                anchors.verticalCenter: (root.verticalCenter)
                anchors.rightMargin:    (0)
                property int padding:   (20)

                CircularGauge {
                    id:                     speedometer
                    width:                  (parent.width)
                    height:                 (parent.height)
                    z:                      (1)

                    value:                  (valueSource.speed)
                    maximumValue:           (200)
                    tickmarksVisible:       (false)
                    //property real ndlAngle: (map(valueSource.speed, 0, 100, -135, 135))

                    anchors {
                        top:                (parent.top)
                        left:               (parent.left)
                        margins:            (speedometerContainer.padding)
                        leftMargin:         (0)
                        rightMargin:        (0)
                    }

                    style: DashboardGaugeStyle {
                        isIndicatorOn:      (true)
                        isGearOn:           (true)
                        tailX:              (180)
                        tailY:              (624)
                        mainLabel:          ("m/min")
                        mainFontSize:       (toPixels(0.55))
                        labelSteps:         (10)
                    }

                    NumberAnimation {
                        //target: speedometer
                        target: needle
                        //property: "ndlAngle"
                        //to: map(valueSource.speed, 0, 100, -135, 135)
                        easing.type: Easing.InOutQuad
                        duration: 10
                    }
                }
            }
            //  Speedometer End
            //  ================================================================


            //  ================================================================
            //  RPMGauge
            Item {
                id:                     rpmGaugeContainer
                width:                  (height * 0.75)
                height:                 (container.height * 0.75)
                anchors.verticalCenter: (root.verticalCenter)
                property int padding:   (20)

                CircularGauge {
                    id:                     rpmGauge
                    width:                  (parent.width)
                    height:                 (parent.height)
                    z:                      (1)

                    value:                  (valueSource.rpm)
                    maximumValue:           (700)
                    tickmarksVisible:       (false)
                    //property real ndlAngle: (map(valueSource.speed, 0, 100, -135, 135))

                    anchors {
                        top:                    (parent.top)
                        left:                   (parent.left)
                        margins:                (rpmGaugeContainer.padding)
                        topMargin:              (rpmGaugeContainer.padding + 80)
                        leftMargin:             (0)
                        rightMargin:            (0)
                    }

                    style: DashboardGaugeStyle {
                        isIndicatorOn:          (false)
                        isGearOn:               (false)
                        tailX:                  (120)
                        tailY:                  (624)
                        mainLabel:              ("rpm")
                        mainFontSize:           (toPixels(0.45))
                        labelSteps:             (50)
                    }

                    NumberAnimation {
                        //target: rpmGauge
                        //property: "ndlAngle"
                        target: needle
                        //to: map(valueSource.rpm, 0, 100, -135, 135)
                        easing.type: Easing.InOutQuad
                        duration: 60
                    }
                }
            }
            //  RPMGauge End
            //  ================================================================
        }
    }
    //  Content Container End
    //  ========================================================================
}
