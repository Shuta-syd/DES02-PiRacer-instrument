import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import com.test.canDataReceiver 1.0

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("DBusClient")

    DBusClient {
        id: client
    }

    Row {
        SpinBox {
            id: spinbox
            width: 200
            height: 50
            value: 0
        }
        Button {
            id: send
            width: 100
            height: 50
            text: "Send"
            onClicked: client.setSpeed(spinbox.value)
        }
    }

    Text {
        anchors.centerIn: parent
        width: 100
        height: 100
        font.pixelSize: 24
        text: "speed=%1".arg(client.speed)
    }
}
