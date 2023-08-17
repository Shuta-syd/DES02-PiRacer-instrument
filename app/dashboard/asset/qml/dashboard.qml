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

        Item { // buttons
            id:                 buttons
            anchors.top:        (parent.top)
            anchors.left:       (parent.left)
            anchors.leftMargin: (10)
            anchors.topMargin:  (12)

            Row {
                spacing: 8
                Rectangle { width: 12; height: 12; color: "#FF4D00"; radius: 7 }
                Rectangle { width: 12; height: 12; color: "#FFE500"; radius: 7 }
                Rectangle { width: 12; height: 12; color: "#08EA1E"; radius: 7 }
            }
        }

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
                text:               (Math.min(valueSource.level, 100) + "%  " + valueSource.left_hour + " hours")
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
                    width:                  (parent.width - 20)
                    height:                 (parent.height - 10)
                    z:                      (1)

                    value:                  (valueSource.consumption)
                    maximumValue:           (100)
                    tickmarksVisible:       (false)

                    anchors {
                        top:                (parent.top)
                        left:               (parent.left)
                        margins:            (consumptionContainer.padding)
                        topMargin:          (consumptionContainer.padding + 20)
                        rightMargin:        (consumptionContainer.padding + 20)
                        bottomMargin:       (0)
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

                //  ========================================================================
                //  Battery Information Rectangle
                Rectangle {
                    id:                         batteryInfoRect
                    width:                      (consumptionContainer.width * 0.9)
                    height:                     (80)
                    color:                      ("#000")
                    border.color:               ("#1EF0FD")
                    border.width:               (1)
                    radius:                     (10)
                    anchors.top:                (consumption.bottom)
                    anchors.topMargin:          (-40)
                    anchors.horizontalCenter:   (consumption.horizontalCenter)
                    z: 10

                    layer.enabled:  (true)
                    layer.effect:   Glow {
                        radius:     (10)
                        color:      Qt.rgba(30, 240, 253, 0.6)
                        spread:     (0.01)
                    }

                    Row {
                        width:                  batteryInfoRect.width * 0.9  // Row의 너비를 Rectangle의 90%로 설정
                        anchors.centerIn:       parent
                        spacing:                10

                        // Label Texts
                        Column {
                            width:                  (parent.width * 0.4)
                            anchors.verticalCenter: (parent.verticalCenter)
                            Text {
                                font.pixelSize:     (16)
                                color:              ("#888888")
                                text:               ("Battery Voltage:")
                                anchors.left:       (parent.left)
                            }
                            Text {
                                font.pixelSize:     (16)
                                color:              ("#888888")
                                text:               ("Current:")
                                anchors.left:       (parent.left)
                            }
                        }

                        // Value Texts
                        Column {
                            width:                  (parent.width * 0.6 - 10)
                            anchors.verticalCenter: (parent.verticalCenter)
                            anchors.rightMargin:    (10)
                             
                            Text {
                                font.pixelSize:     (18)
                                color:              ("#FFF")
                                text:               (valueSource.voltage + "V")
                                horizontalAlignment:(Text.AlignRight)
                                anchors.right:      (parent.right)
                            }
                            Text {
                                font.pixelSize:     (18)
                                color:              ("#FFF")
                                text:               (valueSource.current + "mA")
                                horizontalAlignment:(Text.AlignRight)
                                anchors.right:      (parent.right)
                            }
                        }
                    }
                }
                //  ========================================================================
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
                property int padding:   (20)

                CircularGauge {
                    id:                     speedometer
                    width:                  (parent.width - 40)
                    height:                 (parent.height - 40)
                    z:                      (1)

                    value:                  (valueSource.speed)
                    maximumValue:           (60)
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
                width:                  (height * 0.8)
                height:                 (container.height * 0.8)
                anchors.verticalCenter: (root.verticalCenter)
                property int padding:   (20)

                CircularGauge {
                    id:                     rpmGauge
                    width:                  (parent.width - 20)
                    height:                 (parent.height - 20)
                    z:                      (1)

                    value:                  (valueSource.rpm)
                    maximumValue:           (600)
                    tickmarksVisible:       (false)

                    anchors {
                        top:                (parent.top)
                        left:               (parent.left)
                        margins:            (rpmGaugeContainer.padding)
                        topMargin:          (rpmGaugeContainer.padding + 80)
                    }

                    style: DashboardGaugeStyle {
                        isIndicatorOn:      (false)
                        isGearOn:           (false)
                        tailX:              (120)
                        tailY:              (624)
                        mainLabel:          ("rpm (x10)")
                        mainFontSize:       (toPixels(0.45))
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
