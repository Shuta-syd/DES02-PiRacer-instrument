#ifndef DBUSCLIENT_H
#define DBUSCLIENT_H

#include <QtCore/QObject>

class DBusClient : public QObject
{
  Q_OBJECT
  Q_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)
public:
  explicit DBusClient(QObject *parent = nullptr);
  ~DBusClient();

    int getSpeed() const; // NOT export
    Q_INVOKABLE void reset();  // export

public Q_SLOTS:
  void setSpeed(int);

Q_SIGNALS:
  void speedChanged(int);

private:
  class Private;
  Private *dbus;
};

#endif // DBUSCLIENT_H
