#include "dbusclient.h"
#include <QDBusReply>
#include <QDebug>


DBusClient::DBusClient(QObject *parent)
    : QObject{parent}, _iface(Q_NULLPTR), _dbus(QDBusConnection::sessionBus())
{
  QDBusConnection::sessionBus().registerService("com.test.canDataReceiver");
  QDBusConnection::sessionBus().registerObject("/com/test/canDataReceiver/data", this, QDBusConnection::ExportAllSlots);
}

DBusClient::~DBusClient() {}

void DBusClient::setData(int rpm, int speed)
{
    _speed = speed;
    _rpm = rpm;

    qDebug() << speed;
    qDebug() << rpm;

    emit speedChanged();
    emit rpmChanged();
}
