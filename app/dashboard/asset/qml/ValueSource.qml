import  QtQuick 2.2

Item {
    id:                         valueSource
    objectName:                 "valueSource"

    //  about directions
    property real   steering:   (0.0)   // (float)          // -1 ~ 1
    property real   throttle:   (0.0)   // (float)          // -100~100
    property real   indicator:  (1)     // (int)            // 0:nothing, 1:left, 2:right, 3:warning light

    //  about battery
    property double voltage:    (0.0)   // (float)          // V
    property double consumption:(100.0) // (float)          // W
    property double current:    (0.0)   // (float)          // mA
    property double level:      (50.0)  // (float)          // %, (0~100)
    property real   left_hour:  (3.0)   // (float)

    //  about speed
    property real   speed:      (55)    // (unsigned short) // m/min
    property real   rpm:        (300)   // (unsigned short)

    property string gear: {
        if (throttle === 0)     return ("P");
        if (throttle <   0)     return ("R");
        if (throttle >   0)     return ("D");
    }
    property string ip_address: ("192.168.0.0")
    property string time:       (Qt.formatTime(new Date(), "hh:mm"))
}
