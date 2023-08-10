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
# include <QDBusInterface>
# include <QDBusConnection>
# include <QDBusReply>

# define    FAILURE     -1
# define    SUCCESS     0

int main(int _arc, char* _arv[]) {
    QGuiApplication app(_arc, _arv);

    QDBusInterface *iface = Q_NULLPTR;
    iface = new QDBusInterface ("com.test.canDataReceiver", "com/test/canDataReceiver", "com.test.canDataReceiver", QDBusConnection::sessionBus());
    QMetaObject::invokeMethod(iface, "reset");
    QDBusReply<int> reply = iface->call("getRpm");

    qDebug() << reply.value();

    app.exec();

    /**
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
    **/


    return 0;
}
