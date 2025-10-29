#include "peakmapbluez.h"
#include "peakmapdevice.h"
PeakMapBluez::PeakMapBluez(QObject *parent)
    : QObject{parent}
{
}
PeakMapBluez::~PeakMapBluez(){
    if(this->devices.length() > 0){
        for(auto x : devices){
            x->disconnectDevice();
            delete x ;
        }
    }
    this->discoveryAgent->stop();

    this->devices.clear();
    this->discoveryAgent->deleteLater();
}
void PeakMapBluez::discoverBluez(){

    try{
        qDebug() << "Starting ?";
    if(discoveryAgent != nullptr){

        delete discoveryAgent;
        this->devices.clear();


    }
    }catch(std::runtime_error &err){
        qDebug() << err.what();
    }
    this->discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    this->discoveryAgent->setLowEnergyDiscoveryTimeout(25000);
    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this , &PeakMapBluez::scannedDevices);
    this->discoveryAgent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);

}


void PeakMapBluez::scannedDevices(const QBluetoothDeviceInfo &info){
    qDebug() << scanWaitingCount;
    if(info.coreConfigurations() &QBluetoothDeviceInfo::LowEnergyCoreConfiguration){
        qDebug() << info.name() << " : " << info.address() << info.serviceIds();
        auto device = new PeakMapDevice(info);
         if(!device->getName().contains("PEAKMAP")){
            scanWaitingCount++;
            return;

        }
        auto it = std::find_if(devices.begin(),devices.end(),
                               [device](PeakMapDevice *dev){
                                   return dev->getDeviceAddress() == dev->getDeviceAddress();

        });
        if(it == devices.end()){
            devices.append(device);
        }else{
            auto oldDev = *it;
            *it =device;
            delete oldDev;

        }
        qDebug() << devices.length();
        emit deviceUpdated();

    }
}

void PeakMapBluez::errorOccurred(){

}
void PeakMapBluez::finished(){

}
void PeakMapBluez::cancelled(){}

QList<PeakMapDevice*> PeakMapBluez::getDevices(){
    return this->devices;
}

void PeakMapBluez::stopScan(){
    this->discoveryAgent->stop();

}
