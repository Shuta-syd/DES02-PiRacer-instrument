import  QtQuick 2.2


Item {
    id:                         valueSource
    objectName:                 "valueSource"

    //  about directions
    property real   throttle:   (0.0)   // (float)          // -100~100
    property real   steering:   (0.0)   // (float)          // -1 ~ 1
    property real   indicator:  (0)     // (int)            // 0:nothing, 1:left, 2:right, 3:warning light

    //  about battery
    property double voltage:    (0.0)   // (float)          // V
    property double consumption:(0.0)   // (float)          // W
    property double current:    (0.0)   // (float)          // mA
    property double level:      (100.0) // (float)          // %, (0~100)
    property real   left_hour:  (4.0)   // (float)

    //  about speed
    property real   speed:      (0)     // (unsigned short) // m/min
    property real   rpm:        (0)     // (unsigned short)

    property string gear: {
        if (throttle === 0)     return ("P");
        if (throttle <   0)     return ("R");
        if (throttle >   0)     return ("D");
    }
    property string ip_address: ("192.168.0.0")
    property string time:       (Qt.formatTime(new Date(), "hh:mm"))

    //  about alarm
    QtObject {
        id:                         alarmTypeEnum
        readonly property int       _warn:      (1)
        readonly property int       _infor:     (2)
        readonly property int       _debug:     (3)
    }

    // QtObject {
    //     id:                         alarmClass

    //     property int                type:       0
    //     property string             message:    ""
    //     property date               timestamp:  new Date()

    //     function alarmTypeToString(type) {
    //         switch (type) {
    //             case alarmTypeEnum._warn:       return "warning";
    //             case alarmTypeEnum._infor:      return "information";
    //             case alarmTypeEnum._debug:      return "debug";
    //             default:                        return "unknown";
    //         }
    //     }
    // }
    // property var alarmQueue: [
    //     {
    //         type:       alarmTypeEnum._infor,
    //         message:    "dashboard app started successfully",
    //         timestamp:  new Date()
    //     },
    // ];
    // function addAlarm(type, message) {
    //     let newAlarm = Qt.createQmlObject('import QtQuick 2.2; QtObject { }', valueSource);
    //     newAlarm.type = type;
    //     newAlarm.message = message;
    //     newAlarm.timestamp = new Date();

    //     alarmQueue.push(newAlarm);
    //     alarmTimer.start();
    // }
    // Connections {
    //     target: valueSource
    //     onAlarmQueueChanged: {
    //         listView.model = valueSource.alarmQueue
    //     }
    // }
}
