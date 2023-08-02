import  QtQuick                 2.2
import  QtQuick.Window          2.1
import  QtQuick.Controls        1.4
import  QtQuick.Controls.Styles 1.4
import  QtQuick.Extras          1.4

Window {
  id:       root
  visible:  (true)
  width:    (1024)
  height:   (600)
  color:    ("#161616")
  title:    ("Qt Quick Extras Demo")

  ValueSource {
      id:     valueSource
  }

  //  Dashboards are typically in a landscape orientation, so we need to ensure
  //  our height is never greater than our width.
  Item {
      id:               container
      width:            (root.width)
      height:           (Math.min(root.width, root.height))
      anchors.centerIn: (parent)

      Row {
          id:               gaugeRow
          spacing:          (container.width * 0.02)
          anchors.centerIn: (parent)

//          TurnIndicator {
//              id:                     leftIndicator
//              anchors.verticalCenter: (parent.verticalCenter)
//              width:                  (height)
//              height:                 (container.height * 0.1) - (gaugeRow.spacing)
//              direction:              (Qt.LeftArrow)
//              on:                     (valueSource.turnSignal == Qt.LeftArrow)
//          }

          Item {
              width:                  height
              height:                 container.height * 0.25
                                      - gaugeRow.spacing
              anchors.verticalCenter: parent.verticalCenter

              CircularGauge {
                  id:                   fuelGauge
                  value:                valueSource.fuel
                  maximumValue:         1
                  y:                    parent.height / 2
                                        - height / 2
                                        - container.height * 0.01
                  width:                parent.width
                  height:               parent.height * 0.7

                  style: IconGaugeStyle {
                      id:                 fuelGaugeStyle

                      icon:               "qrc:/asset/images/fuel.icon.png"
                      minWarningColor:    Qt.rgba(0.5, 0, 0, 1)

                      tickmarkLabel: Text {
                          color:            "white"
                          visible:          (styleData.value === 0) ||
                                            (styleData.value === 1)
                          font.pixelSize:   fuelGaugeStyle.toPixels(0.225)
                          text:             (styleData.value === 0) ?
                                              "E" :
                                              ((styleData.value === 1) ?
                                                "F" :
                                                "")
                      }
                  }
              }

              CircularGauge {
                  value:                valueSource.temperature
                  maximumValue:         1
                  width:                parent.width
                  height:               parent.height * 0.7
                  y:                    parent.height / 2 +
                                        container.height * 0.01

                  style: IconGaugeStyle {
                      id:                 tempGaugeStyle
                      icon:               "qrc:/asset/images/temperature.icon.png"
                      maxWarningColor:    Qt.rgba(0.5, 0, 0, 1)

                      tickmarkLabel: Text {
                          color:            "white"
                          visible:          (styleData.value === 0) ||
                                            (styleData.value === 1)
                          font.pixelSize:   tempGaugeStyle.toPixels(0.225)
                          text:             (styleData.value === 0) ?
                                              "C" :
                                              ((styleData.value === 1) ?
                                                "H" :
                                                "")
                      }
                  }
              }
          }

          CircularGauge {
              id:                     speedometer
              /*
                We set the width to the height, because the height will always be
                the more limited factor. Also, all circular controls letterbox
                their contents to ensure that they remain circular. However, we
                don't want to extra space on the left and right of our gauges,
                because they're laid out horizontally, and that would create
                large horizontal gaps between gauges on wide screens.
              */
              width:                  (height)
              height:                 (container.height * 0.5)
              anchors.verticalCenter: (parent.verticalCenter)

              value:                  valueSource.kph
              maximumValue:           (400)

              style: DashboardGaugeStyle {
              }
          }

          CircularGauge {
              id:                     tachometer
              width:                  (height)
              height:                 (container.height * 0.25) - (gaugeRow.spacing)
              anchors.verticalCenter: (parent.verticalCenter)

              value:                  (valueSource.rpm)
              maximumValue:           (8)

              style: TachometerStyle {
              }
          }

//          TurnIndicator {
//              id:                     rightIndicator
//              width:                  (height)
//              height:                 (container.height * 0.1) - (gaugeRow.spacing)
//              anchors.verticalCenter: (parent.verticalCenter)

//              direction:              (Qt.RightArrow)
//              on:                     (valueSource.turnSignal == Qt.RightArrow)
//          }

      }
  }
}
