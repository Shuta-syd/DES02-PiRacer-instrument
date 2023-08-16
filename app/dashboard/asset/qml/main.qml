import  QtQuick                 2.15
import  QtQuick.Window          2.15
import  QtQuick.Controls        2.15
import  QtQuick.Controls.Styles 1.4
import  QtQuick.Extras          1.4

Window {
    id:       root
    title:    "QT5 based dashboard"
    width: 1024
    height: 600
    visible: true
    color:    "#161616"

    ValueSource {
        id:  valueSource
    }

    Item {
      id:               container
      width:            root.width
      height:           Math.min(root.width, root.height)
      anchors.centerIn: parent

      Row {
        id:               gaugeRow
        spacing:          (container.width * 0.02)
        anchors.centerIn: (parent)

        CircularGauge {
          id:                     speed_meter
          width:                  height
          height:                 container.height * 0.5
          anchors.verticalCenter: parent.verticalCenter

          value:                  valueSource.speed
          maximumValue:           80
          style: DashboardGaugeStyle {}
      }

        CircularGauge {
          id:                     rpm_meter
          width:                  height
          height:                 container.height * 0.5
          anchors.verticalCenter: parent.verticalCenter

          value:                  valueSource.rpm
          maximumValue:           500
          style: TachometerStyle {}
      }
    }
  }
}
