#ifndef DBUSCLIENT_H
#define DBUSCLIENT_H

#include <QtCore/QObject>
#include <QDBusInterface>
#include <QDBusConnection>
#include <QTimer>


class DBusClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float speed READ speed NOTIFY speedChanged)   // Property for speed.
    Q_PROPERTY(float rpm READ rpm NOTIFY rpmChanged)         // Property for rpm.
public:
    explicit DBusClient(QObject *parent = nullptr);
    ~DBusClient();

    // getter
    Q_INVOKABLE qreal speed() const;
    Q_INVOKABLE qreal rpm() const;

  public Q_SLOTS:
    void setData();

Q_SIGNALS:
    void speedChanged(int);
    void rpmChanged(int);

private:
  QDBusConnection _dbus;
  QDBusInterface* _iface;
  double _speed;
  double _rpm;
  double _battery;
};

#endif // DBUSCLIENT_H
