import  QtQuick                 2.15
import  QtQuick.Window          2.15
import  QtQuick.Controls        2.15
import  QtQuick.Controls.Styles 1.4
import  QtQuick.Extras          1.4
import com.test.canDataReceiver 1.0

Window {
    id:       root
    title:    "QT5 based dashboard"
    width: 1024
    height: 600
    visible: true
    property real speed: 0
    property real rpm: 0

    DBusClient {
        id: dbus_client
        onSpeedChanged: {
          root.speed = dbus_client.speed();
        }
        onRpmChanged: {
          root.rpm = dbus_client.rpm();
        }
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
          id:                     speedometer
          width:                  height
          height:                 container.height * 0.5
          anchors.verticalCenter: parent.verticalCenter

          value:                  root.rpm
          maximumValue:           80
          style: DashboardGaugeStyle {}
      }
    }
  }
}
