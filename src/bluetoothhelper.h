#ifndef BLUETOOTHHELPER_H
#define BLUETOOTHHELPER_H

#include <QObject>
#include <QBluetoothLocalDevice>

class BluetoothHelper : public QObject
{
    Q_OBJECT
public:
    explicit BluetoothHelper(QObject *parent = nullptr);

    Q_INVOKABLE void ensureBluetoothEnabled();

signals:
    void bluetoothEnabled();
    void bluetoothDisabled();
    void bluetoothRequestCancelled();
};

#endif // BLUETOOTHHELPER_H
