//  library for QT frontend
# include   <QtGui/QGuiApplication>
# include   <QtQml/QQmlApplicationEngine>
# include   <QtGui/QFont>
# include   <QtGui/QFontDatabase>
# include

//  library for QT socket communication
# include   <QtNetwork/QTcpSocket>
# include   <QTextStream>
# include   <QtQml/QQmlContext>

//  macros
# define    FAILURE     -1
# define    SUCCESS     0
# define    HOST        "localhost"
# define    PORT        "12345"

//  main
int         main(
    int     _arc,
    char*   _arv[]
) {
    QGuiApplication _app(_arc, _arv);

    // Set DejaVu Sans Font
    QFontDatabase::addApplicationFont(":/asset/fonts/DejaVuSans.ttf");
    _app.setFont(QFont("DejaVu Sans"));

    // Create and initialize the engine
    QQmlApplicationEngine _engine(QUrl("qrc:/asset/qml/dashboard.qml"));
    if (_engine.rootObjects().isEmpty())
        return  (FAILURE);

    // Find the root object
    QObject* _root = _engine.rootObjects().first();

    // Find valueSource in the root object
    QObject* _valueSource = _root->findChild<QObject*>("valueSource");
    if (!_valueSource) {
        qWarning() << "Cannot find object named 'valueSource'";
        return  (FAILURE);
    }

    // Create and initialize the socket
    QTcpSocket* _socket = new QTcpSocket();
    QObject::connect(_socket, &QTcpSocket::connected, [](){
        qDebug() << "Connected to the server";
    });

    // Try to connect to the server
    socket->connectToHost(HOST, PORT);  // Change host and port as needed
    if (!_socket->waitForConnected(3000)) {
        qDebug() << "Error: " << _socket->errorString();
        return  (FAILURE);
    }

    // Update the properties when data is ready
    QObject::connect(_socket, &QTcpSocket::readyRead, [_socket, _valueSource](){
        QTextStream T(_socket);
        QString _msg = T.readAll();
        QStringList _list = _msg.split(",");
        if(_list.size() == 2) {
            _valueSource->setProperty("kph", _list[0].toDouble());
            _valueSource->setProperty("rpm", _list[1].toDouble());
        } else {
            qDebug() << "Unexpected message format: " << msg;
        }
    });

    return  (_app.exec());
}
