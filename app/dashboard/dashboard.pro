TEMPLATE    =   app
TARGET      =   dashboard
INCLUDEPATH +=  .
QT          +=  quick

SOURCES     +=  \
                main.cpp
RESOURCES   +=  \
                dashboard.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

OTHER_FILES += \
                asset/qml/dashboard.qml \
                asset/qml/DashboardGaugeStyle.qml \
                asset/qml/ValueSource.qml

DISTFILES += \
    asset/qml/new_GearButton.qml \
    asset/qml/new_SpeedGauge.qml \
    asset/qml/new_dashboard.qml

