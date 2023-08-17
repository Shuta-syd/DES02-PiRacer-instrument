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

// Library for JSON parsing
# include   <QJsonDocument>
# include   <QJsonObject>
# include   <QJsonValue>


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

    //  Set Futura Heavy Font
    QStringList fonts;
    QList<int> fontIds;
    
    fonts.append("Futura_Heavy.ttf");
    fonts.append("Futura_Heavy_Italic.ttf");
    fonts.append("Futura_Bold.otf");
    for (int i=0; i<fonts.size(); i++)
    {
        fontIds.append(QFontDatabase::addApplicationFont(":/asset/fonts/" + fonts[i]));
        if (fontIds[i] == -1)
        {
            qWarning() << fonts[i] << "file not found";
            return  (FAILURE);
        }
        else
            qDebug() << "font id:" << fontIds[i] << "/" << fonts[i] << "was appended. ";
    }

    QStringList fontFamilies = QFontDatabase::applicationFontFamilies(2);
    if (!fontFamilies.isEmpty()) {
        QString fontFamily = fontFamilies.at(0);
        app.setFont(QFont(fontFamily));
    } else {
        qWarning() << "No font families found for Futura_Bold.otf";
        return FAILURE;
    }

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
    QList<QList<QString> properties = [
        ["throttle",            "float",    "throttle"],
        ["steering",            "float",    "steering"],
        ["indicator",           "float",    "indicator"],
        ["battery_voltage",     "float",    "voltage"],
        ["power_consumption",   "float",    "consumption"],
        ["battery_current",     "float",    "current"],
        ["battery_current",     "float",    "current"],
        ["battery_level",       "float",    "level"],
        ["battery_hour",        "float",    "hour"],
        ["speed",               "short",    "speed"],
        ["rpm",                 "short",    "rpm"],
        ["ip_address",          "string",    "ip_address"],
        ["curtime",             "string",   "curtime"],
    ]
    QList<QPropertyAnimation> animations;
    for (int i=0; i<properties.size(); i++) {
        animations[i] = new QPropertyAnimation(valueSource, properties[i][0])
        animations[i]->setDuration(400);
    }

    QStringList logList;
    QObject::connect(socket, &QTcpSocket::readyRead, [socket, valueSource, speedAnimation, rpmAnimation]() {
        QTextStream     _T(socket);
        QString         _msg = _T.readAll();

        QJsonDocument   _json = QJsonDocument::fromJson(_msg.toUtf8());
        if (!_json.isNull())
        {
            QJsonObject _jsonObj = _json.object();
            for (int i=0; i<properties.size(); i++)
            {
                auto _data = _jsonObj[properties[i]];
                auto _updatedData;
                if (properties[i][1] == "float")
                    _updatedData = _data.toDouble();
                else if (properties[i][1] == "string")
                    _updatedData = _data;
                else if (properties[i][1] == "short")
                    _updatedData = _data.toInt();

                animations[i]->setEndValue(_updatedData);
                if (animations[i]->state() != QPropertyAnimation::Running)
                    animations[i]->start();
            }
        }
        else
            qWarning() << "Invalid JSON: " << _msg;
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
