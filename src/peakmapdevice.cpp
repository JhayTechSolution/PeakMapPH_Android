#include "peakmapdevice.h"
#include <QBluetoothAddress>
#include <QBluetoothUuid>
#include <QJSEngine>
#include "peakmapservice.h"
PeakMapDevice::PeakMapDevice(const QBluetoothDeviceInfo &devInfo , QObject *parent)
    : QObject{parent}
{
    this->deviceInfo = devInfo;
}

PeakMapDevice::~PeakMapDevice(){
    qDebug() << "TRYING TO DISCONNECT THE DEVICE";
    if(this->controller != nullptr){
        this->disconnectDevice();
        this->deleteLater();

    }
}
QString PeakMapDevice::getName(){
    return this->deviceInfo.name();
}

QString PeakMapDevice::getDeviceAddress(){
    return this->deviceInfo.address().toString();
}
void PeakMapDevice::connectDevice(){

    controller = QLowEnergyController::createCentral(this->deviceInfo, this);
    connect(controller , &QLowEnergyController::connected, this, &PeakMapDevice::connected);
    connect(controller, &QLowEnergyController::discoveryFinished , this , &PeakMapDevice::serviceScanDone);
    connect(controller, &QLowEnergyController::serviceDiscovered, this , &PeakMapDevice::serviceDiscovered);
    connect(controller,&QLowEnergyController::disconnected, this , &PeakMapDevice::deviceDisconnected);
    controller->setRemoteAddressType(QLowEnergyController::PublicAddress);
    controller->connectToDevice();
}

void PeakMapDevice::serviceScanDone(){
    this->service = PeakMapService::createService(controller, this->deviceInfo.deviceUuid().toString());

    qDebug() << "Emitting serviceCreated with:" << service
             << "metaType:" << QMetaType::typeName(QMetaType::fromType<PeakMapService*>().id());

    emit serviceCreated(QVariant::fromValue(service));
}
void PeakMapDevice::serviceDiscovered(const QBluetoothUuid &newService){
    qDebug() << "Discovered services " << newService;
}
void PeakMapDevice::connected(){
    qDebug() <<"Discovering services";
    controller->discoverServices();

}

void PeakMapDevice::deviceDisconnected(){
    disconnectDevice();
    emit disconnected();
}

void PeakMapDevice::disconnectDevice(){
    if(controller){
        qDebug() << "TRYING TO DELETE SERVICe";
        if(service){
            delete service;
            service = nullptr;
        }
        qDebug() << "disconnting";
        if(controller->state() == QLowEnergyController::ConnectedState){
            controller->disconnectFromDevice();
        }
        controller->deleteLater();
        qDebug()<<"deleting";
        controller = nullptr;
        emit disconnected();
    }
}
