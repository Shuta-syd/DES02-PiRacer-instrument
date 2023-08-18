#ifndef DBUSCLIENT_H
#define DBUSCLIENT_H

#include <QtCore/QObject>
#include <QDBusInterface>
#include <QDBusConnection>
#include <QTimer>


class DBusClient : public QObject
{
    Q_OBJECT
public:
    explicit DBusClient(QObject *parent = nullptr);
    ~DBusClient();

    // getter
    qreal speed();
    qreal rpm();
    qreal batteryInfo();
    Q_INVOKABLE qreal getRpm() { return _rpm; }
    Q_INVOKABLE qreal getSpeed() { return _speed; }
    Q_INVOKABLE qreal getVoltage() { return _voltage; }
    Q_INVOKABLE qreal getCurrent() { return _current; }
    Q_INVOKABLE qreal getConsumption() { return _consumption; }
    Q_INVOKABLE qreal getLevel() { return _level; }

  public Q_SLOTS:
    void setData();

Q_SIGNALS:
    void speedChanged(qreal);
    void rpmChanged(qreal);
    void voltageChanged(qreal);
    void levelChanged(qreal);
    void consumptionChanged(qreal);
    void currentChanged(qreal);

public:
  QDBusConnection _dbus;
  QDBusInterface* _iface;
  qreal _speed;
  qreal _rpm;
  qreal _current;
  qreal _consumption;
  qreal _voltage;
  qreal _level;
};

#endif // DBUSCLIENT_H
