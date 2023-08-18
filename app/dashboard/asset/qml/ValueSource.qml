import  QtQuick 2.2
import com.test.dbusService 1.0

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
    property real   speed:      (0)    // (unsigned short) // m/min
    property real   rpm:        (0)    // (unsigned short)
    property real   prev_speed: (0)
    property real   prev_rpm:   (0)

    property string gear: {
        if (throttle === 0)     return ("P");
        if (throttle <   0)     return ("R");
        if (throttle >   0)     return ("D");
    }


    DBusClient {
        id: dbus_client
        onRpmChanged: {
          valueSource.prev_rpm = valueSource.rpm
          valueSource.rpm = dbus_client.getRpm();
        }
        onSpeedChanged: {
          valueSource.prev_speed = valueSource.speed
          valueSource.speed = dbus_client.getSpeed();
        }
    }
    property string time:       (Qt.formatTime(new Date(), "hh:mm"))
    property int animationDuration: 400 // Set animation duration for properties

    NumberAnimation on speed {
      duration: animationDuration
      easing.type: Easing.InOutQuad

      from: valueSource.prev_speed

      to: valueSource.speed

      onRunningChanged: {
          if (!running) {
              start();
          }
      }
    }

    NumberAnimation on rpm {
      duration: animationDuration
      easing.type: Easing.InOutQuad

      from: valueSource.prev_rpm

      to: valueSource.rpm

      onRunningChanged: {
          if (!running) {
              start();
          }
      }
    }
}
