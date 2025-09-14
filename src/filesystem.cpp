#include "filesystem.h"
#include <QFile>
#include <QDebug>
FileSystem::FileSystem(QObject *parent)
    : QObject{parent}
{}


QByteArray FileSystem::readFileString(QString filePath){
    if(filePath.startsWith("qrc:")){
        filePath = filePath.replace("qrc:", ":");
    }

    QFile f(filePath);
    if(!f.exists()){
        qDebug() << filePath << " Not found";
        return QByteArray();
    }
    if(!f.open(QIODevice::ReadOnly)){
        qDebug() << "Unable to open "<< filePath;
        return QByteArray();
    }

    auto data=   f.readAll();
    f.close();
    return data;
}
