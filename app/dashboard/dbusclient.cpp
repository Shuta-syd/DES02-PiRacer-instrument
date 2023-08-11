#include "dbusclient.h"
#include <QDBusInterface>
#include <QDBusConnection>
#include <QDBusReply>
#include <QDebug>

class DBusClient::Private
{
public:
  Private();
  ~Private();
  QDBusConnection dbus = QDBusConnection::sessionBus();
  QDBusInterface *iface = Q_NULLPTR;
}

DBusClient::Private::Private()
{
  QDBusInterface iface("com.test.canDataReceiver", "/com/test/canDataReceiver", "com.test.canDataReceiver", this->dbus);
  if (!iface)
  {
    qWarning() << "failed to make DBusInterface";
    exit(1);
  }
}

DBusClient::Private::~Private()
{
  if (iface)
    delete iface;
}

DBusClient::DBusClient(QObject *parent)
    : QObject{parent}, dbus{new Private}
{
  // connect SIGNAL(DBusServer::speedChanged)
  bool flag = this->dbus->iface->connection().connect(dbus->iface->service(),
                                                      dbus->iface->path(),
                                                      dbus->iface->interface(),
                                                      QStringLiteral("speedChanged"),
                                                      this,
                                                      SLOT(speedChanged(int)));
  if (!flag)
  {
    qDebug() << "failed to connect DBus signal";
  }

  // for debug
  connect(this, &DBusClient::countChanged,
          [](int speed)
          {
            qDebug() << "speedChanged" << speed;
          });
}

DBusClient::~DBusClient()
{
  delete dbus;
}

int DBusClient::getSpeed() const
{
  QDBusReply<int> reply = dbus->iface->call("getRpm");
  int value = reply.value();
  return value;
}

void DBusClient::reset()
{
    QMetaObject::invokeMethod(dbus->iface, "reset");
}

void DBusClient::setCount(int newSpeed)
{
  this->dbus->iface->setProperty("speed", QVariant(newSpeed));
}
