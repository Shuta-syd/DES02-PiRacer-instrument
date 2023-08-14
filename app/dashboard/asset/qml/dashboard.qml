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

    // =========================================================================
    // Top Navbar
    Item {
        id:     navbarContainer
        width:  (root.width)
        height: (30)

        Item { // buttons
            anchors.top:        parent.top
            anchors.left:       parent.left
            anchors.leftMargin: 10
            anchors.topMargin:  12

            Row {
                spacing: 8
                Rectangle { width: 12; height: 12; color: "red"; radius: 7 }
                Rectangle { width: 12; height: 12; color: "yellow"; radius: 7 }
                Rectangle { width: 12; height: 12; color: "green"; radius: 7 }
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
                text:               (Qt.formatTime(timeSource.currentTime, "hh:mm"))

                layer.effect: Glow { // shading effect
                    radius:             10
                    samples:            16
                    color:              (Qt.rgba(1,1,1,1))
                    source:             timeText
                }
            }

            Timer {
                id: timeSource
                interval: 60000 // every 60 second
                running: true
                repeat: true
                property date currentTime: new Date()

                onTriggered: {
                    currentTime = new Date()
                }
            }
        }
    }
    // Top Navbar Finish
    // =========================================================================

    // =========================================================================
    // Content Container
    Item {
        id:               container
        width:            (root.width)
        height:           (Math.min(root.width, root.height) - navbarContainer.height)

        Row {
            id:               gaugeRow
            spacing:          (container.width * 0.02)
            anchors.centerIn: (parent)

            TurnIndicator {
                id:                     leftIndicator
                anchors.verticalCenter: (parent.verticalCenter)
                width:                  (height)
                height:                 (container.height * 0.1) - (gaugeRow.spacing)
                direction:              (Qt.LeftArrow)
                on:                     (valueSource.turnSignal == Qt.LeftArrow)
            }

            // Item {
            //     width:                  height
            //     height:                 container.height * 0.25
            //                             - gaugeRow.spacing
            //     anchors.verticalCenter: parent.verticalCenter

            //     CircularGauge {
            //         id:                   fuelGauge
            //         value:                valueSource.fuel
            //         maximumValue:         1
            //         y:                    parent.height / 2
            //                                 - height / 2
            //                                 - container.height * 0.01
            //         width:                parent.width
            //         height:               parent.height * 0.7

            //         style: IconGaugeStyle {
            //             id:                 fuelGaugeStyle

            //             icon:               "qrc:/asset/images/fuel.icon.png"
            //             minWarningColor:    Qt.rgba(0.5, 0, 0, 1)

            //             tickmarkLabel: Text {
            //                 color:            "white"
            //                 visible:          (styleData.value === 0) ||
            //                                     (styleData.value === 1)
            //                 font.pixelSize:   fuelGaugeStyle.toPixels(0.225)
            //                 text:             (styleData.value === 0) ?
            //                                     "E" :
            //                                     ((styleData.value === 1) ?
            //                                         "F" :
            //                                         "")
            //             }
            //         }
            //     }

            //     CircularGauge {
            //         value:                valueSource.temperature
            //         maximumValue:         1
            //         width:                parent.width
            //         height:               parent.height * 0.7
            //         y:                    parent.height / 2 +
            //                                 container.height * 0.01

            //         style: IconGaugeStyle {
            //             id:                 tempGaugeStyle
            //             icon:               "qrc:/asset/images/temperature.icon.png"
            //             maxWarningColor:    Qt.rgba(0.5, 0, 0, 1)

            //             tickmarkLabel: Text {
            //                 color:            "white"
            //                 visible:          (styleData.value === 0) ||
            //                                     (styleData.value === 1)
            //                 font.pixelSize:   tempGaugeStyle.toPixels(0.225)
            //                 text:             (styleData.value === 0) ?
            //                                     "C" :
            //                                     ((styleData.value === 1) ?
            //                                         "H" :
            //                                         "")
            //             }
            //         }
            //     }
            // }

            CircularGauge {
                id:                     speedometer
                width:                  (height)
                height:                 (container.height)
                // anchors.verticalCenter: (root.verticalCenter)
                anchors.topMargin:      (25)

                value:                  valueSource.spd
                maximumValue:           (60)

                style: DashboardGaugeStyle {
                }
            }

            // CircularGauge {
            //     id:                     tachometer
            //     width:                  (height)
            //     height:                 (container.height * 0.25) - (gaugeRow.spacing)
            //     anchors.verticalCenter: (parent.verticalCenter)

            //     value:                  (valueSource.rpm)
            //     maximumValue:           (8)

            //     style: TachometerStyle {
            //     }
            // }

            TurnIndicator {
                id:                     rightIndicator
                width:                  (height)
                height:                 (container.height * 0.1) - (gaugeRow.spacing)
                anchors.verticalCenter: (parent.verticalCenter)

                direction:              (Qt.RightArrow)
                on:                     (valueSource.turnSignal == Qt.RightArrow)
            }

        }
    }
    }
