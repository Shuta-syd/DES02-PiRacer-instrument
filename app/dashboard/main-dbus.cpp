# include   <QtGui/QGuiApplication>
# include   <QtQml/QQmlApplicationEngine>
# include   <QtGui/QFont>
# include   <QtGui/QFontDatabase>

//  library for QT log
# include   <QFile>
# include   <QTextStream>
# include   <QDebug>

//  library for QT animation
# include   <QPropertyAnimation>

// library for QDbus
#include <QDBusConnection>
#include <QDBusInterface>
#include <QtDBus>

#include <iostream>

# define    FAILURE     -1
# define    SUCCESS     0

int main(int _arc, char* _arv[]) {
    QGuiApplication app(_arc, _arv);


    //connect to DBus session-bus
    QDBusConnection bus = QDBusConnection::sessionBus();
    if (!bus.isConnected()){
        std::cerr<<"Error connecting to D-Bus session-bus\n";
        return EXIT_FAILURE;
    }

    QDBusInterface iface("com.test.canDataReceiver", "/com/test/canDataReceiver", "com.test.canDataReceiver", bus);
    if (!iface.isValid()) {
        std::cerr << "Failed to connect to the D-Bus interface" << std::endl;
        return 1;
    }
    while (true) {
        QDBusReply<int> reply = iface.call("getRpm");
        if (reply.isValid()) {
            int rpm = reply.value();
            std::cout << "\rRPM: " << rpm;
        } else {
            std::cout << "\rNo value";
        }
    }


    //  Set DejaVu Sans Font
    QFontDatabase::addApplicationFont(":/asset/fonts/DejaVuSans.ttf");
    app.setFont(QFont("DejaVu Sans"));

    //  Create and initialize the engine
    QQmlApplicationEngine engine(QUrl("qrc:/asset/qml/dashboard.qml"));
    if (engine.rootObjects().isEmpty())
        return  (FAILURE);

    //  Find the root object
    QObject* root = engine.rootObjects().first();

    //  Find valueSource in the root object
    QObject* valueSource = root->findChild<QObject*>("valueSource");
    if (!valueSource)
    {
        qWarning() << "Cannot find object named 'valueSource'";
        return  (FAILURE);
    }

    return (app.exec());
}
