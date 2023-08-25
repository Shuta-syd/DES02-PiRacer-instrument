#include "dbusclient.h"
#include <QDBusReply>
#include <QDebug>
#include <vector>

#define CLOCK_TIME 100

DBusClient::DBusClient(QObject *parent)
    : QObject{parent}, _dbus(QDBusConnection::sessionBus()), _iface(Q_NULLPTR), _speed(0), _rpm(0)
{
  QTimer *timer = new QTimer(this);
  connect(timer, &QTimer::timeout, this, &DBusClient::setData);
  timer->start(CLOCK_TIME);

  connectToDBus();
}

void DBusClient::connectToDBus()
{
    this->_iface = new QDBusInterface("com.test.dbusService", "/com/test/dbusService", "com.test.dbusService");
    if (!_iface->isValid()) {
        qDebug() << "Interface not valid: " << qPrintable(_iface->lastError().message());
    }
}

void DBusClient::reconnectDBus()
{
    qDebug() << "DBus connection lost. Attempting to reconnect...";
    connectToDBus();
}

DBusClient::~DBusClient() {
  if (_iface)
    delete _iface;
}


qreal DBusClient::speed() {
  QDBusMessage response = _iface->call("getSpeed");

  if (response.type() == QDBusMessage::ErrorMessage) {
      qDebug() << "Error: " << qPrintable(response.errorMessage());
      return 0;
  }
  qreal value = response.arguments().at(0).toInt();
  return value;
}

qreal DBusClient::rpm() {
  QDBusMessage response = _iface->call("getRpm");

  if (response.type() == QDBusMessage::ErrorMessage) {
      qDebug() << "Error: " << qPrintable(response.errorMessage());
      return 0;
  }

  qreal value = response.arguments().at(0).toInt();
  return value;
}

void DBusClient::batteryInfo() {
  QDBusMessage response = _iface->call("getBatteryInfo");

  if (response.type() == QDBusMessage::ErrorMessage) {
      qDebug() << "Error: " << qPrintable(response.errorMessage());
      this->_level = this->_consumption = this->_voltage = this->_current = 0;
      return;
  }

  QList<QVariant> responseData = response.arguments();
    this->_level = responseData.at(0).toString().toDouble();
    this->_hour = responseData.at(1).toString().toDouble();
    this->_consumption = responseData.at(2).toString().toDouble();
    this->_voltage = responseData.at(3).toString().toDouble();
    this->_current = responseData.at(4).toString().toDouble();

    qDebug() << "Battery Level: " << _level;
    qDebug() << "Voltage: " << _voltage;
    qDebug() << "Consumption: " << _consumption;
    qDebug() << "Current: " << _current;
}

void DBusClient::setData() {
  this->_rpm = this->rpm();
  this->_speed = this->speed();
  this->batteryInfo();

  qDebug() << "rpm: " << this->_rpm << " speed: " << this->_speed;
  //qDebug() << "level: " this->_level << " consumption: " << this._consumption << " voltage: " << this->_voltage;

  emit rpmChanged(_rpm);
  emit speedChanged(_speed);
  emit voltageChanged(_voltage);
  emit currentChanged(_current);
  emit consumptionChanged(_consumption);
  emit levelChanged(_level);
  emit LeftHourChanged(_hour);
}
