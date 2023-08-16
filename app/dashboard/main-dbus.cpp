# include   <QtGui/QGuiApplication>
# include   <QtQml/QQmlApplicationEngine>
# include   <QtGui/QFont>
# include   <QtGui/QFontDatabase>

//  library for QT log
# include   <QFile>
# include   <QTextStream>
# include   <QDebug>

#include <iostream>
#include "dbusclient.h"


int main(int _arc, char* _arv[]) {
    QGuiApplication app(_arc, _arv);
    DBusClient client();

    qmlRegisterType<DBusClient>("com.test.dbusService", 1, 0, "DBusClient");

    //  Set DejaVu Sans Font
    QFontDatabase::addApplicationFont(":/asset/fonts/DejaVuSans.ttf");
    app.setFont(QFont("DejaVu Sans"));

    //  Create and initialize the engine
    QQmlApplicationEngine engine;
    QUrl url("qrc:/asset/qml/main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
      if (!obj && url == objUrl)
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return (app.exec());
}
