#ifndef DBUSCLIENT_H
#define DBUSCLIENT_H

#include <QtCore/QObject>
#include <QDBusInterface>
#include <QDBusConnection>


class DBusClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int speed READ getSpeed WRITE setSpeed NOTIFY speedChanged)
public:
    explicit DBusClient(QObject *parent = nullptr);
    ~DBusClient();

    int getSpeed() const;

public Q_SLOTS:
    void setSpeed(int);

Q_SIGNALS:
    void speedChanged(int);

private:
    int _speed;
    QDBusInterface *_iface;
    QDBusConnection _dbus;
};

#endif // DBUSCLIENT_H
