TEMPLATE    =   app
TARGET      =   dashboard
INCLUDEPATH +=  .
QT          +=  quick dbus

SOURCES     +=   main.cpp \
                 dbusclient.cpp

RESOURCES   +=  dashboard.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

OTHER_FILES += \
                asset/qml/main.qml \
                asset/qml/DashboardGaugeStyle.qml \
                asset/qml/ValueSource.qml \

HEADERS += \
    dbusclient.h
DISTFILES += \
    asset/qml/new_GearButton.qml \
    asset/qml/new_SpeedGauge.qml \
    asset/qml/new_dashboard.qml
