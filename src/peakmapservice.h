#ifndef PEAKMAPSERVICE_H
#define PEAKMAPSERVICE_H

#include <QObject>
#include <QLowEnergyService>
#include <QLowEnergyController>
#include <QLowEnergyCharacteristic>
class PeakMapService : public QObject
{
    Q_OBJECT
public:
    explicit PeakMapService(QObject *parent = nullptr);
    ~PeakMapService();
    static PeakMapService *createService(QLowEnergyController *controller, QString charUUid);

    Q_INVOKABLE void sendData(QByteArray data);
private:
    QLowEnergyService *service;
    QLowEnergyCharacteristic character;
    QLowEnergyCharacteristic writeCharacter;
    QLowEnergyCharacteristic readCharacter;
    QString charUUid;
    void scanService(QLowEnergyController *controller);
    void sendAck(int seq);
    QString fixedServiceID ="904abe34-fa69-415b-b6ba-7bfc2204bf46";
signals:
    void receivedData(QByteArray data);
    void serviceReady();

public slots:
    void serviceStateChanged(QLowEnergyService::ServiceState state);
    void characteristicChnaged(const QLowEnergyCharacteristic &chr, const QByteArray &value);
};

#endif // PEAKMAPSERVICE_H
