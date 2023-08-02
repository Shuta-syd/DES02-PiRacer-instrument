import  QtQuick 2.2

//! [0]
Item {
    id:             valueSource
    property real   kph:    (0)
    property real   rpm:    (1)
    property real   fuel:   (1)
    property string gear: {
        if (kph == 0)
            return "P";
        if (kph < 30)
            return "1";
        if (kph < 50)
            return "2";
        if (kph < 80)
            return "3";
        if (kph < 120)
            return "4";
        if (kph < 160)
            return "5";
    }
//    property int    turnSignal:     (gear == "P") && ((!start) ? (randomDirection()) : (-1))
    property real   temperature:    (0.5)
    property bool   start:          (true)
//! [0]

//    function randomDirection() {
//        return  ((Math.random() > 0.5) ? Qt.LeftArrow : Qt.RightArrow);
//    }

    SequentialAnimation {
        running:    (true)
        loops:      (1)

        // We want a small pause at the beginning, but we only want it to happen once.
        PauseAnimation {
            duration:   (1000)
        }

        PropertyAction {
            target:     (valueSource)
            property:   ("start")
            value:      (false)
        }

        SequentialAnimation {
            loops:      (Animation.Infinite)

//! [1]
            ParallelAnimation {
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    from:           (0)
                    to:             (30)
                    duration:       (3000)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("rpm")
                    easing.type:    (Easing.InOutSine)
                    from:           (1)
                    to:             (6.1)
                    duration:       (3000)
                }
            }
//! [1]

            ParallelAnimation {
                // We changed gears so we lost a bit of speed.
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    from:           (30)
                    to:             (26)
                    duration:       (600)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("rpm")
                    easing.type:    (Easing.InOutSine)
                    from:           (6)
                    to:             (2.4)
                    duration:       (600)
                }
            }
            ParallelAnimation {
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (60)
                    duration:       (3000)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("rpm")
                    easing.type:    (Easing.InOutSine)
                    to:             (5.6)
                    duration:       (3000)
                }
            }
            ParallelAnimation {
                // We changed gears so we lost a bit of speed.
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (56)
                    duration:       (600)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (2.3)
                    duration:       (600)
                }
            }
            ParallelAnimation {
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (100)
                    duration:       (3000)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (5.1)
                    duration:       (3000)
                }
            }
            ParallelAnimation {
                // We changed gears so we lost a bit of speed.
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (96)
                    duration:       (600)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (2.2)
                    duration:       (600)
                }
            }

            ParallelAnimation {
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (140)
                    duration:       (3000)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (6.2)
                    duration:       (3000)
                }
            }

            // Start downshifting.

            // Fifth to fourth gear.
            ParallelAnimation {
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.Linear)
                    to:             (100)
                    duration:       (5000)
                }

                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (3.1)
                    duration:       (5000)
                }
            }

            // Fourth to third gear.
            NumberAnimation {
                target:         (valueSource)
                property:       ("kph")
                easing.type:    (Easing.InOutSine)
                to:             (5.5)
                duration:       (600)
            }

            ParallelAnimation {
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (60)
                    duration:       (5000)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (2.6)
                    duration:       (5000)
                }
            }

            // Third to second gear.
            NumberAnimation {
                target:         (valueSource)
                property:       ("kph")
                easing.type:    (Easing.InOutSine)
                to:             (6,3)
                duration:       (600)
            }

            ParallelAnimation {
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (30)
                    duration:       (5000)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (2.6)
                    duration:       (3000)
                }
            }

            NumberAnimation {
                target:         (valueSource)
                property:       ("kph")
                easing.type:    (Easing.InOutSine)
                to:             (6.5)
                duration:       (600)
            }

            // Second to first gear.
            ParallelAnimation {
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (0)
                    duration:       (5000)
                }
                NumberAnimation {
                    target:         (valueSource)
                    property:       ("kph")
                    easing.type:    (Easing.InOutSine)
                    to:             (1)
                    duration:       (4500)
                }
            }

            PauseAnimation {
                duration:       (5000)
            }
        }
    }
}
