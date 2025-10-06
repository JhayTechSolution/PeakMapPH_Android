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
void registerObject(){
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

    qmlRegisterUncreatableMetaObject( SQLite::staticMetaObject,"Com.Plm.PeakMapPH",1,0,"SQLite","Enum only");
    QZXing::registerQMLTypes();
}
#include <QPluginLoader>
int main(int argc, char *argv[])
{
    //QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    //QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGLRhi);
    QPluginLoader lib("libplugins_sqldrivers_qsqlite_arm64-v8a.so");
    if(!lib.load()){
        qDebug() << lib.errorString();
    }
    QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);

    QApplication app(argc, argv);

 //   FelgoApplication felgo;

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/");
    qRegisterMetaType<QImage>("QImage");
    registerObject();
 //   felgo.initialize(&engine);

    // Set an optional license key from project file
    // This does not work if using Felgo Developer App, only for Felgo Cloud Builds and local builds
 //    felgo.setLicenseKey("260C4CB69866E3F31C7C48404E0BCD8571A976A40C1DBE912407CA7D1E712A86120D01D346087624CB63FE7A06892C3E0C7A4AA25423F05ED81EBCDFFAD75D7CF941BC2A30C6E8A9449C17CD2BC579FD3DA3360FEC221834C57167A92C50CD3A4175D08078B78FCB315B0B7E3795E6E9A1C6F14C9AA7E31C501D0D754937ABA9EA5E42D5B5648C358EDAB3C9ED92B11EE985BABE4A2E0C85AAA44E37071B3CDBB7A318B4717033647392140B78DD0490298CD0A4F594C352108D7A27F1CBFC0666C6ED7D4201C97E1CAA529EFD8A9155E0615FB485A9276CEBC1656D5C00D8F40FF81B94B6B740C186EDFECF9F3F28A69FBDF3A7D1DA19D4041F424181936083C0BE24DF9BF5A3843561BE05762E40BCC8D7E260159F7A8E60A63E2AD482B780A0DC1BD14CF37B35AE1FF7FC9520F1DD");
   // felgo.setLicenseKey("com.plm.PeakMapPH");
    // use this during development
    // for PUBLISHING, use the entry point below
    QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    // use this instead of the above call to avoid deployment of the qml files and compile them into the binary with qt's resource system qrc
    // this is the preferred deployment option for publishing apps to the app stores, because then your qml files and js files are protected
    // to avoid deployment of your qml files and images, also comment the deploy_resources command in the CMakeLists file
    // also see the CMakeLists.txt file for more details
    //felgo.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml"));

     engine.load(url);


    // to start your project with Felgo Hot Reload, comment (remove) the lines "felgo.setMainQmlFileName ..." & "engine.load ...",
    // and uncomment the line below
    //FelgoHotReload felgoHotReload(&engine);
     if(engine.rootObjects().isEmpty()){
         return -1;
     }



    return app.exec();
}
