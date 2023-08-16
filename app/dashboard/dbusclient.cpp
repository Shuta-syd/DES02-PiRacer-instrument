#include "dbusclient.h"
#include <QDBusReply>
#include <QDebug>

DBusClient::DBusClient(QObject *parent)
    : QObject{parent}, _dbus(QDBusConnection::sessionBus()), _iface(Q_NULLPTR), _speed(0), _rpm(0)
{
  QTimer *timer = new QTimer(this);
  connect(timer, &QTimer::timeout, this, &DBusClient::setData);
  timer->start(1);

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


qreal DBusClient::speed() {
  QDBusReply<QVariant> reply = _iface->call("getSpeed", this->_rpm);
  qreal value = reply.value().toReal();

  return value;
}

qreal DBusClient::rpm() {
    QDBusMessage response = _iface->call("getRpm");

    if(response.type() == QDBusMessage::ErrorMessage) {
        qDebug() << "Error: " << qPrintable(response.errorMessage());
        exit(1);
    }
    qreal value = response.arguments().at(0).toInt();
    return value;
}

void DBusClient::setData() {
  this->_rpm = this->rpm();
  this->_speed = speed();

  emit rpmChanged(_rpm);
  emit speedChanged(_speed);
}
