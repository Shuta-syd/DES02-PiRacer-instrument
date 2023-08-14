import  QtQuick 2.2

Item {
    id:             valueSource
    objectName:     "valueSource"
    property real   spd:    (42)
    property real   rpm:    (1)
    property real   fuel:   (1)
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
}
