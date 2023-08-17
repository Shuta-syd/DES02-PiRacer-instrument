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
    DBusClient client();
    QGuiApplication app(_arc, _arv);

    qmlRegisterType<DBusClient>("com.test.dbusService", 1, 0, "DBusClient");

    //  font setting
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
    QQmlApplicationEngine engine;
    QUrl url("qrc:/asset/qml/dashboard.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
      if (!obj && url == objUrl)
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return (app.exec());
}
