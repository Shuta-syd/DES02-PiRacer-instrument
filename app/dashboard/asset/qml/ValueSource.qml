import  QtQuick 2.2
import com.test.dbusService 1.0

Item {
    id:             valueSource
    objectName:     "valueSource"
    property real   speed:  0
    property real   rpm:    0
    property string gear: {
        if (spd == 0)
            return "P";
        if (spd < 10)
            return "1";
        if (spd < 20)
            return "2";
        if (spd < 30)
            return "3";
        if (spd < 40)
            return "4";
        if (spd < 50)
            return "5";
    }

    DBusClient {
        id: dbus_client
        onRpmChanged: {
          valueSource.rpm = dbus_client.getRpm();
        }
        onSpeedChanged: {
          valueSource.speed = dbus_client.getSpeed();
        }
    }
}
