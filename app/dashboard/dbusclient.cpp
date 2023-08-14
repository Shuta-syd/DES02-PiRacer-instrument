#include "dbusclient.h"
#include <QDBusReply>
#include <QDebug>


DBusClient::DBusClient(QObject *parent)
    : QObject{parent}, _iface(Q_NULLPTR), _dbus(QDBusConnection::sessionBus())
{

  _iface = new QDBusInterface("com.test.canDataReceiver", "/com/test/canDataReceiver", "com.test.canDataReceiver", QDBusConnection::sessionBus());
  if (!_iface)
  {
    qWarning() << "failed to make DBusInterface";
    exit(1);
  }

  // connect SIGNAL(DBusServer::speedChanged)
  bool flag = this->_iface->connection().connect(_iface->service(),
                                                      _iface->path(),
                                                      _iface->interface(),
                                                      QStringLiteral("speedChanged"),
                                                      this,
                                                      SLOT(speedChanged(int)));
  if (!flag)
  {
    qDebug() << "failed to connect DBus signal";
  }

  // for debug
  connect(this, &DBusClient::speedChanged,
          [](int speed)
          {
            qDebug() << "speedChanged" << speed;
          });
}

DBusClient::~DBusClient()
{
  delete _iface;
}

int DBusClient::getSpeed() const
{
  QDBusReply<int> reply = _iface->call("getRpm");
  int value = reply.value();
  return value;
}

void DBusClient::setSpeed(int newSpeed)
{
  this->_iface->setProperty("speed", QVariant(newSpeed));
}
