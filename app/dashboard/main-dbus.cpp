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

#include <iostream>
#include "dbusclient.h"

# define    FAILURE     -1
# define    SUCCESS     0

int main(int _arc, char* _arv[]) {
    QGuiApplication app(_arc, _arv);

    qmlRegisterType<DBusClient>("com.test.canDataReceiver", 1, 0, "DBusClient");

    //  Set DejaVu Sans Font
    QFontDatabase::addApplicationFont(":/asset/fonts/DejaVuSans.ttf");
    app.setFont(QFont("DejaVu Sans"));

    QObject::connect(QQuickWindow::beforeRendering)

    //  Create and initialize the engine
    QUrl url("qrc:/asset/qml/main.qml");
    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
      if (!obj && url == objUrl)
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return (app.exec());
}
