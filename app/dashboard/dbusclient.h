#ifndef DBUSCLIENT_H
#define DBUSCLIENT_H

#include <QtCore/QObject>
#include <QDBusInterface>
#include <QDBusConnection>


class DBusClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float speed READ speed NOTIFY speedChanged)   // Property for speed.
    Q_PROPERTY(float rpm READ rpm NOTIFY rpmChanged)         // Property for rpm.
public:
    explicit DBusClient(QObject *parent = nullptr);
    ~DBusClient();

    // getter
    double speed() const { return _speed; }
    double rpm() const { return _rpm; }

  public Q_SLOTS:
    void setData(int, int); // rpm, speed

Q_SIGNALS:
    void speedChanged();
    void rpmChanged();
    void batteryChanged();

private:
    int _speed;
    size_t _speed;
    size_t _rpm;
    size_t _battery;
};

#endif // DBUSCLIENT_H
