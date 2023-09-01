import  QtQuick                 2.2
import  QtQuick.Window          2.1
import  QtQuick.Controls        1.4
import  QtQuick.Controls.Styles 1.4
import  QtQuick.Extras          1.4
import  QtGraphicalEffects      1.0


Window {
    id:             root
    title:          "dashboard"
    visible:        (true)
    width:          (1248)
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

        Item { // battery icon
            id:                 batteryIcon
            width:              (35)
            height:             (13)
            anchors.top:        (parent.top)
            anchors.left:       (buttons.right)
            anchors.leftMargin: (65)
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
            anchors.leftMargin:     (9)

            Text {
                text:               (parseInt(Math.min(valueSource.level, 100)) + "%  " + parseInt(valueSource.left_hour) + " hours"
                                    + "\n" + parseInt(valueSource.voltage) + " V " + " " + parseInt(valueSource.current) + " mA" + parseInt(valueSource.gear))
                font.pixelSize:     (18)
                color:              ("white")
            }
        }

        Item { // timer
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
    //  Top Navbar End
    //  ========================================================================


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
                visible:                (true)

                CircularGauge {
                    id:                     consumption
                    width:                  (parent.width - 10)
                    height:                 (parent.height - 10)
                    z:                      (1)

                    value:                  (valueSource.consumption)
                    maximumValue:           (25)
                    tickmarksVisible:       (false)

                    anchors {
                        top:                (parent.top)
                        left:               (parent.left)
                        margins:            (consumptionContainer.padding)
                        topMargin:          (consumptionContainer.padding + 80)
                    }

                    style: DashboardGaugeStyle {
                        isIndicatorOn:      (false)
                        isGearOn:           (false)
                        tailX:              (145)
                        tailY:              (624)
                        mainLabel:          ("battery consumption (W)")
                        mainFontSize:       (toPixels(0.45))
                    }
                }

            //  ================================================================
            //  Speedometer
            Item {
                id:                     speedometerContainer
                width:                  (height)
                height:                 (container.height)
                anchors.verticalCenter: (root.verticalCenter)
                property int padding:   (20)

                CircularGauge {
                    id:                     speedometer
                    width:                  (parent.width - 40)
                    height:                 (parent.height - 40)
                    z:                      (1)

                    value:                  (valueSource.speed)
                    maximumValue:           (180)
                    tickmarksVisible:       (false)

                    anchors {
                        top:                (parent.top)
                        left:               (parent.left)
                        margins:            (speedometerContainer.padding)
                    }

                    style: DashboardGaugeStyle {
                        isIndicatorOn:      (true)
                        isGearOn:           (true)
                        tailX:              (160)
                        tailY:              (624)
                        mainLabel:          ("m/min")
                        mainFontSize:       (toPixels(0.55))
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
                    width:                  (parent.width - 10)
                    height:                 (parent.height - 10)
                    z:                      (1)

                    value:                  (valueSource.rpm)
                    maximumValue:           (600)
                    tickmarksVisible:       (false)

                    anchors {
                        top:                    (parent.top)
                        left:                   (parent.left)
                        margins:                (rpmGaugeContainer.padding)
                        topMargin:              (rpmGaugeContainer.padding + 80)
                    }

                    style: DashboardGaugeStyle {
                        isIndicatorOn:          (false)
                        isGearOn:               (false)
                        tailX:                  (120)
                        tailY:                  (624)
                        mainLabel:              ("rpm (x10)")
                        mainFontSize:           (toPixels(0.45))
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
}
