#ifndef PEAKMAPBLUEZ_H
#define PEAKMAPBLUEZ_H

#include <QObject>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
Q_MOC_INCLUDE("peakmapdevice.h")

#include <QLowEnergyController>
class PeakMapDevice;
class PeakMapBluez : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<PeakMapDevice*> devices READ getDevices)

public:
    explicit PeakMapBluez(QObject *parent = nullptr);
    ~PeakMapBluez();
    Q_INVOKABLE void discoverBluez();
    QList<PeakMapDevice*> getDevices();
    Q_INVOKABLE void stopScan();

private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent = nullptr;
    QList<PeakMapDevice*> devices;
    PeakMapDevice *controller;
    int scanWaitingCount= 0;
signals:
    void deviceUpdated();
    void scannedComplete();
    void scanError();
    void cancelledScan();


private slots:
    void scannedDevices(const QBluetoothDeviceInfo &info);
    void errorOccurred();
    void finished();
    void cancelled();

};

#endif // PEAKMAPBLUEZ_H
