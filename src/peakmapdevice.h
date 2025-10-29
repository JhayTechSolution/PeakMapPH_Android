#ifndef PEAKMAPDEVICE_H
#define PEAKMAPDEVICE_H

#include <QObject>
#include <QBluetoothDeviceInfo>
#include <QLowEnergyController>
#include <QBluetoothUuid>
#include <QJSValue>
Q_MOC_INCLUDE("peakmapservice.h")
class PeakMapService;
class PeakMapDevice : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName)
    Q_PROPERTY(QString address READ getDeviceAddress)
public:
    explicit PeakMapDevice(const QBluetoothDeviceInfo &info, QObject *parent = nullptr);
    ~PeakMapDevice();
    QString getName();
    QString getDeviceAddress();
    Q_INVOKABLE void connectDevice();
    Q_INVOKABLE void disconnectDevice();

private:
    QBluetoothDeviceInfo deviceInfo;
    QLowEnergyController *controller;
    PeakMapService *service;

signals:
    void disconnected();
    void serviceCreated(QVariant peakMapService);

private slots:
    void connected();
    void deviceDisconnected();
    void serviceDiscovered(const QBluetoothUuid &uuid);
    void serviceScanDone();
};

#endif // PEAKMAPDEVICE_H
