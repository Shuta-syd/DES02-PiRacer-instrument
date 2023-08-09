//  library for QT frontend
# include   <QtGui/QGuiApplication>
# include   <QtQml/QQmlApplicationEngine>
# include   <QtGui/QFont>
# include   <QtGui/QFontDatabase>

//  library for QT socket communication
# include   <QtNetwork/QTcpSocket>
# include   <QTextStream>
# include   <QtQml/QQmlContext>

//  library for QT log
# include   <QFile>
# include   <QTextStream>

//  library for QT animation
# include   <QPropertyAnimation>


//  macros
# define    FAILURE     -1
# define    SUCCESS     0
# define    HOST        "localhost"
# define    PORT        23513

//  main
int         main(
    int     _arc,
    char*   _arv[]
) {
    QGuiApplication app(_arc, _arv);

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

    //  Create and initialize the socket
    QTcpSocket* socket = new QTcpSocket();
    QObject::connect(socket, &QTcpSocket::connected, []()
    {
        qDebug() << "Connected to the server";
    });

    //  Try to connect to the server
    socket->connectToHost(HOST, PORT);
    if (!socket->waitForConnected(3000))
    {
        qDebug() << "Error: " << socket->errorString();
        return  (FAILURE);
    }

    //  Create animations for smooth transitions
    QPropertyAnimation* speedAnimation = new QPropertyAnimation(valueSource, "spd");
    speedAnimation->setDuration(400); // You can adjust the duration for smoothness
    QPropertyAnimation* rpmAnimation = new QPropertyAnimation(valueSource, "rpm");
    rpmAnimation->setDuration(400); // You can adjust the duration for smoothness

    //  Update the properties when data is ready
    QStringList logList;
    QObject::connect(socket, &QTcpSocket::readyRead, [socket, valueSource, speedAnimation, rpmAnimation]() {
        QTextStream _T(socket);
        QString _msg = _T.readAll();
        QStringList _list = _msg.split(",");
        if (_list.size() == 2) {
            // Smooth transition for speed
            speedAnimation->setEndValue(_list[0].toDouble());
            if (speedAnimation->state() != QPropertyAnimation::Running)
                speedAnimation->start();
            // Smooth transition for rpm
            rpmAnimation->setEndValue(_list[1].toDouble());
            if (rpmAnimation->state() != QPropertyAnimation::Running)
                rpmAnimation->start();
        } else {
            qWarning() << "Unexpected message format: " << _msg;
        }
    });

    int result = app.exec();

    QFile file("log/log.txt");
    if (file.open(QIODevice::WriteOnly))
    {
        QTextStream stream(&file);
        for (const QString &log : logList)
            stream << log << "\n";
    }

    return result;
}
