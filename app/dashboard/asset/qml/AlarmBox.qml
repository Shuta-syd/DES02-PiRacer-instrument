// import  QtQuick             2.2
// import  QtGraphicalEffects  1.0


// Item {
//     id: alarmBox
//     width: parent.width * 0.85
//     height: 45
//     anchors.centerIn: parent

//     // Alarm properties from valueSource
//     property var alarm: null

//     // Color code variables
//     readonly property color informationColor: "#7CFC00"
//     readonly property color warningColor: "#FF4500"
//     readonly property color defaultColor: "#FFFFFF"
//     readonly property var alarmTypeEnum: valueSource.alarmTypeEnum  // Adding this line to access the enum

//     property color borderColor: switch (alarm.type) {
//         case 1:   return warningColor;
//         case 2:   return informationColor;
//         default:  return defaultColor;
//     }

//     Rectangle {
//         anchors.fill: parent
//         color: Qt.rgba(0, 0, 0, 1)
//         border.color: borderColor
//         border.width: 2
//         radius: 10

//         Rectangle {
//             width: 40  // Increased icon size
//             height: 40
//             anchors.verticalCenter: parent.verticalCenter
//             anchors.left: parent.left
//             anchors.leftMargin: 10
//             color: "darkgray"
//             radius: 20

//             Text {
//                 anchors.centerIn: parent
//                 text: "i"
//                 color: "white"
//                 font.pixelSize: 24  // Increased font size for the icon
//             }
//         }

//         Text {
//             anchors.verticalCenter: parent.verticalCenter
//             anchors.left: parent.left
//             anchors.leftMargin: 60
//             anchors.right: dateText.left
//             elide: Text.ElideRight
//             text: alarm ? alarm.message : ""
//             color: "white"
//             font.pixelSize: 18  // Increased font size for the alarm message
//         }

//         Text {
//             id: dateText
//             anchors.verticalCenter: parent.verticalCenter
//             anchors.right: parent.right
//             anchors.rightMargin: 10
//             color: "gray"
//             font.pixelSize: 14  // Increased font size for the date
//             text: alarm ? Qt.formatDate(alarm.timestamp, "yyyy.MM.dd hh:mm") : ""
//         }
//     }

//     DropShadow {
//         anchors.fill: alarmBox
//         cached: true
//         radius: 5
//         samples: 16
//         color: borderColor
//         source: alarmBox
//     }

//     Component.onCompleted: {
//         if (alarm) {
//             alarmTimer.start(); // Timer를 시작합니다.
//         }
//     }

//     Timer {
//         id: alarmTimer
//         interval: 5000
//         running: false // 기본값으로 false를 설정합니다.
//         repeat: false  // 일회성 타이머로 설정합니다.
//         onTriggered: {
//             var index = valueSource.alarmQueue.indexOf(alarmBox.alarm)
//             if (index !== -1) {
//                 valueSource.alarmQueue.splice(index, 1);
//             }
//         }
//     }
// }
