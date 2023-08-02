# include   <QtGui/QGuiApplication>
# include   <QtQml/QQmlApplicationEngine>
# include   <QtGui/QFont>
# include   <QtGui/QFontDatabase>

# define    FAILURE -1
# define    SUCCESS 0

int         main(
    int     _arc,
    char*   _arv[]
) {
    QGuiApplication app(_arc, _arv);

    QFontDatabase::addApplicationFont(":/asset/fonts/DejaVuSans.ttf");
    app.setFont(QFont("DejaVu Sans"));

    QQmlApplicationEngine engine(QUrl("qrc:/asset/qml/dashboard.qml"));
    if (engine.rootObjects().isEmpty())
        return (FAILURE);
    return (app.exec());
}
