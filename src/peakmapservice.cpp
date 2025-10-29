#include "peakmapservice.h"
#include <QLowEnergyDescriptor>
#include <QJsonObject>
#include <QJsonDocument>
#include <QThread>
PeakMapService::PeakMapService(QObject *parent)
    : QObject{parent}
{}
PeakMapService::~PeakMapService(){

    qDebug() << "deleting the peakmap service? ";
    delete service;
    service = nullptr;
}

PeakMapService *PeakMapService::createService(QLowEnergyController *controller, QString uuid) {
    qDebug() << " UUID " << uuid;
    PeakMapService *pms = new PeakMapService();
    pms->scanService(controller);
    return pms;
}
void PeakMapService::scanService(QLowEnergyController *controller){
    auto services = controller->services();

    if(!services.isEmpty()){
//        auto serv= services[1];
        for(auto s: services){
            auto serv = controller->createServiceObject(s, this);
            if(serv->serviceUuid().toString().contains(this->fixedServiceID)){
                qDebug() << "FOUND "<< serv->serviceUuid();
                this->service = serv;
                if(service){
                    connect(service ,&QLowEnergyService::stateChanged, this , &PeakMapService::serviceStateChanged);
                    connect(service , &QLowEnergyService::characteristicChanged, this, &PeakMapService::characteristicChnaged);

                    service->discoverDetails();

                }
            }
        }
/*

        this->service = controller->createServiceObject(serv, this);
        qDebug() << this->service->serviceUuid();

        if(service){
            connect(service ,&QLowEnergyService::stateChanged, this , &PeakMapService::serviceStateChanged);
            connect(service , &QLowEnergyService::characteristicChanged, this, &PeakMapService::characteristicChnaged);

            service->discoverDetails();
        }
*/
    }
}

void PeakMapService::characteristicChnaged(const QLowEnergyCharacteristic &chr, const QByteArray &unpacked) {
    static QByteArray buffer;
    if(unpacked != "\n"){
        buffer += unpacked;  // accumulate fragments
        qDebug() << "RECEIVING " << unpacked;
    }
    if (unpacked == "\n") {  // heuristic: last chunk
        QByteArray fullMessage = buffer;
        buffer.clear();

        qDebug() << "[BLE] Received combined Base64 (" << fullMessage.size() << " bytes)";
        emit this->receivedData(fullMessage.toBase64());

    }
    //this->sendAck(17);
}

void PeakMapService::sendAck(int seq){
    QJsonObject obj;
    obj["ack"] = seq;
    QByteArray data = QJsonDocument(obj).toJson(QJsonDocument::Compact);
    service->writeCharacteristic(this->writeCharacter, data, QLowEnergyService::WriteWithoutResponse);

}

void PeakMapService::serviceStateChanged(QLowEnergyService::ServiceState s){

    if(s == QLowEnergyService::ServiceDiscovered){
        qDebug() << "Low energy discovered ";
        for(auto c: service->characteristics()){
            qDebug() << c.properties() << ": "<< QLowEnergyCharacteristic::Notify;
            //if(c.properties() & QLowEnergyCharacteristic::Notify){
            if(c.properties().testFlag(QLowEnergyCharacteristic::Notify) ||
                c.properties().testFlag(QLowEnergyCharacteristic::Indicate)){
                this->character = c;
                qDebug() << "FOUND notify";

            }else if (c.properties().testFlag(QLowEnergyCharacteristic::Write) ||
                       c.properties().testFlag(QLowEnergyCharacteristic::WriteNoResponse) ||
                       c.properties().testFlag(QLowEnergyCharacteristic::WriteSigned)){
                qDebug() << "Found write permission";
                this->writeCharacter = c;
            }
            else if(c.properties().testFlag(QLowEnergyCharacteristic::Read)){
                qDebug() << "Found read ";
                this->readCharacter = c;
            }

        }

    }


    if(this->character.isValid()){
        QLowEnergyDescriptor notificationDesc = this->character.descriptor(QBluetoothUuid::DescriptorType::ClientCharacteristicConfiguration);
        if(notificationDesc.isValid()){
            qDebug() <<"acceptable notification";
            try{
                service->writeDescriptor(notificationDesc,QByteArray::fromHex("0100"));
               emit this->serviceReady();
            }catch(std::runtime_error &err){
                qDebug() << err.what();
            }
        }else{
            qDebug() <<"No notification descriptor";
        }
    }else{
        qDebug() << "No notification characteristics";
    }

}


void PeakMapService::sendData(QByteArray base64Data) {
    if (this->service) {
        QByteArray data = QByteArray::fromBase64(base64Data); // Decode from Base64
        int chunkSize = 20;
        int totalSize = data.size();
        int numChunks = (totalSize + chunkSize - 1) / chunkSize; // Calculate the number of chunks

        for (int i = 0; i < numChunks; ++i) {

            int offset = i * chunkSize;
            QByteArray chunk = data.mid(offset, chunkSize);

             this->service->writeCharacteristic(this->character, chunk, QLowEnergyService::WriteWithoutResponse);

            QThread::msleep(100);
        }
        this->service->writeCharacteristic(this->character, "\n", QLowEnergyService::WriteWithoutResponse);
        qDebug() << data;
        qDebug() << data.length();
        qDebug() << "All chunks sent.";
    }
}
