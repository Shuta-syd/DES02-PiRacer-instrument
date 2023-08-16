#include "dbusclient.h"
#include <QDBusReply>
#include <QDebug>

DBusClient::DBusClient(QObject *parent)
    : QObject{parent}, _dbus(QDBusConnection::sessionBus()), _iface(Q_NULLPTR), _speed(0), _rpm(0)
{
  QTimer *timer = new QTimer(this);
  connect(timer, &QTimer::timeout, this, &DBusClient::setData);
  timer->start(100);

  this->_iface = new QDBusInterface("com.test.dbusService", "/com/test/dbusService", "com.test.dbusService");
  if (!_iface->isValid()) {
      qDebug() << "Interface not valid: " << qPrintable(_iface->lastError().message());
      exit(1);
    }
}

DBusClient::~DBusClient() {
  if (_iface)
    delete _iface;
}


qreal DBusClient::speed() const {
  QDBusReply<QVariant> reply = _iface->call("getSpeed");
  qreal value = reply.value().toReal();


  return value;
}

qreal DBusClient::rpm() const {
  QDBusReply<QVariant> reply = _iface->call("getRpm");
  qDebug() << replay;
  qreal value = reply.value().toReal();
  qDebug() << value;

  return value;
}

void DBusClient::setData() {
  qDebug() << "setData";
  // this->_speed = speed();
  this->_rpm = rpm();

  // emit speedChanged(_speed);
  emit rpmChanged(_rpm);
}
