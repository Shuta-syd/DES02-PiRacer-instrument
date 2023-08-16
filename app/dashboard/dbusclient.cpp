#include "dbusclient.h"
#include <QDBusReply>
#include <QDebug>

DBusClient::DBusClient(QObject *parent)
    : QObject{parent}, _dbus(QDBusConnection::sessionBus()), _iface(Q_NULLPTR)
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
  QDBusReply<qreal> reply = _iface->call("getSpeed");
  qreal value = reply.value();

  return value;
}

qreal DBusClient::rpm() const {
  QDBusReply<qreal> reply = _iface->call("getRpm");
  qreal value = reply.value();

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
