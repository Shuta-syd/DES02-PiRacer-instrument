TEMPLATE    =   app
TARGET      =   dashboard
INCLUDEPATH +=  .
QT          +=  quick dbus

SOURCES     +=   main-dbus.cpp \
                 dbusclient.cpp

RESOURCES   +=  dashboard.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

OTHER_FILES += \
                asset/qml/main.qml
