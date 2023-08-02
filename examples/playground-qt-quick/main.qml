import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: rootId
    width: 640
    height: 480
    visible: true
    title: qsTr("QML Syntax demo")

    property string textToShow: "Hello World"

    Row {
        id: row1
        anchors.centerIn: parent
        spacing: 20

        Rectangle {
            id: redRectId
            width: 150; height: 150
            color: "red"
            radius: 20
            MouseArea {
                anchors.fill:  parent
                onClicked: {
                    console.log("Clicked on the red rectangle")
                    textToShow = "red"
                }
            }
        }

        Rectangle {
            id: greenRectId
            width: 150; height: 150
            color: "green"
            radius: 20
            MouseArea {
                anchors.fill:  parent
                onClicked: {
                    console.log("Clicked on the red rectangle")
                    textToShow = "green"
                }
            }
        }

        Rectangle {
            id: blueRectId
            width: 150; height: 150
            color: "blue"
            radius: 20
            MouseArea {
                anchors.fill:  parent
                onClicked: {
                    console.log("Clicked on the red rectangle")
                    textToShow = "blue"
                }
            }
        }
    }

    Rectangle {
        id: textRectId
        width: 150; height: 150
        color: "dodgerblue"
        radius: 100
        Text {
            id: textId
            anchors.centerIn: parent
            text: textToShow
        }
        MouseArea {
             anchors.fill:  parent
            onClicked: {
                console.log("Clicked on the red rectangle")
            }
        }
    }
}
