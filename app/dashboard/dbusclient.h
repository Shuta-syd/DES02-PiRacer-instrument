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
    Q_INVOKABLE qreal getRpm() { return _rpm; }
    Q_INVOKABLE qreal getSpeed() { return _rpm; }

  public Q_SLOTS:
    void setData();

Q_SIGNALS:
    void speedChanged(qreal);
    void rpmChanged(qreal);

public:
  QDBusConnection _dbus;
  QDBusInterface* _iface;
  qreal _speed;
  qreal _rpm;
  qreal _battery;
};

#endif // DBUSCLIENT_H
