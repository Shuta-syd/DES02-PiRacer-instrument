#include "dbusclient.h"
#include <QDBusReply>
#include <QDebug>
#include <vector>

#define CLOCK_TIME 0.1
#define MAX_SIZE 10
static int speed_i = 1;
static qreal speed_sum = -1;
static int rpm_i = 1;
static qreal rpm_sum = -1;

DBusClient::DBusClient(QObject *parent)
    : QObject{parent}, _dbus(QDBusConnection::sessionBus()), _iface(Q_NULLPTR), _speed(0), _rpm(0)
{
  QTimer *timer = new QTimer(this);
  connect(timer, &QTimer::timeout, this, &DBusClient::setData);
  timer->start(CLOCK_TIME);

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
  QDBusMessage response = _iface->call("getSpeed");

  if (response.type() == QDBusMessage::ErrorMessage) {
      qDebug() << "Error: " << qPrintable(response.errorMessage());
      exit(1);
  }
  qreal value = response.arguments().at(0).toInt();
  speed_sum += value;
  if (speed_i++ == MAX_SIZE) {
      speed_i = 1;
      value = speed_sum / MAX_SIZE;
      speed_sum = 0;
      return value;
  }
  return this->_speed;
}

qreal DBusClient::rpm() {
  QDBusMessage response = _iface->call("getRpm");

  if (response.type() == QDBusMessage::ErrorMessage) {
        qDebug() << "Error: " << qPrintable(response.errorMessage());
        exit(1);
  }
  qreal value = response.arguments().at(0).toInt();
  rpm_sum += value;
  if (rpm_i++ == MAX_SIZE) {
      rpm_i = 1;
      value = rpm_sum / MAX_SIZE;
      rpm_sum = 0;
      return value;
  }
  return this->_rpm;
}

void DBusClient::setData() {
  this->_rpm = this->rpm();
  this->_speed = this->speed();

  qDebug() << "rpm: " << this->_rpm << " speed: " << this->_speed;

  emit rpmChanged(_rpm);
  emit speedChanged(_speed);
}
