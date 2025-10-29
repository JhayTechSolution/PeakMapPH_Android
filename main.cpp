#include <QApplication>
//#include <FelgoApplication>
#include <QQmlApplicationEngine>

// Uncomment this line to add Felgo Hot Reload and use hot reloading with your custom C++ code
//#include <FelgoHotReload>
#include <QDirIterator>
#include <QDir>

#include <QGuiApplication>


#include "filesystem.h"
//#include "peakvideosink.h"
#include "sqlitestorage.h"
#include "sqliteforeignkey.h"
#include "sqliteprimarykey.h"
#include "sqlitetable.h"
#include "sqliteproperty.h"
#include "sqlitedatatype.h"
#include "sqlitekey.h"
#include "sqliteuniquekey.h"
#include "sqliteoperation.h"
//#include <FelgoHotReload>
#include <QQuickWindow>
#include "QZXing.h"
#include "peakqrdecoder.h"
#include <QVideoSink>
#include <QQmlContext>
#include <QImage>
#include <QtPlugin>
#include "peakmapbluez.h"
#include "peakmapdevice.h"
#include "peakmapservice.h"
#include "aeshelper.h"
#include "bluetoothhelper.h"
void registerObject(){
       qRegisterMetaType<PeakMapService*>("PeakMapService*");
   // qmlRegisterType<PeakVideoSink>("Com.Plm.PeakMapPH", 1, 0,"PeakVsink");
    qmlRegisterType<FileSystem>("Com.Plm.PeakMapPH", 1, 0 , "FileSystem");
    qmlRegisterType<SQLiteStorage>("Com.Plm.PeakMapPH",1,0, "SQLiteDB");
    qmlRegisterType<SQLiteForeignKey>("Com.Plm.PeakMapPH",1,0, "SQLiteForeignKey");
    qmlRegisterType<SQLitePrimaryKey>("Com.Plm.PeakMapPH",1,0, "SQLitePrimaryKey");
    qmlRegisterType<SQLiteUniqueKey>("Com.Plm.PeakMapPH",1,0, "SQLiteUniqueKey");
    qmlRegisterType<SQLiteKey>("Com.Plm.PeakMapPH",1,0, "SQLiteKey");

    qmlRegisterType<SQLiteTable>("Com.Plm.PeakMapPH",1,0, "SQLiteTable");
    qmlRegisterType<SQLiteProperty>("Com.Plm.PeakMapPH", 1,0 ,"SQLiteProperty");
    qmlRegisterType<SQLiteOperation>("Com.Plm.PeakMapPH",1,0, "SQLiteOperation");
    qmlRegisterType<PeakQrDecoder>("Com.Plm.PeakMapPH", 1,0 , "PeakQRDecoder");
    qmlRegisterType<PeakMapBluez>("Com.Plm.PeakMapPH", 1, 0 ,"PeakMapBluez");
    qmlRegisterType<PeakMapDevice> ("Com.Plm.PeakMapPH", 1,0 , "PeakMapDevice");
    qmlRegisterType<PeakMapService>("Com.Plm.PeakMapPH",1,0, "PeakMapService");
    qmlRegisterType<AESHelper>("Com.Plm.PeakMapPH", 1,0 ,"AESHelper");
    qmlRegisterType<BluetoothHelper>("Com.Plm.PeakMapPH",1,0,"BluetoothHelper");
    qmlRegisterUncreatableMetaObject( SQLite::staticMetaObject,"Com.Plm.PeakMapPH",1,0,"SQLite","Enum only");
    QZXing::registerQMLTypes();
}
#include <QPluginLoader>
int main(int argc, char *argv[])
{
    QPluginLoader lib("libplugins_sqldrivers_qsqlite_arm64-v8a.so");
    if(!lib.load()){
        qDebug() << lib.errorString();
    }
    QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);

    QGuiApplication app(argc, argv);



    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/");
    qRegisterMetaType<QImage>("QImage");
    registerObject();
    QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    engine.load(url);


        if(engine.rootObjects().empty()){
         return -1;
     }




    return app.exec();
}
