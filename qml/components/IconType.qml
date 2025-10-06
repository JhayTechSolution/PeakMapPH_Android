pragma Singleton
import QtQuick 2.15

QtObject{
    property string _path:"qrc:/assets/svg/%1"
    property string infoCircle: _path.arg("infoCircle.svg")
    property string bello: _path.arg("bello.svg")
    property string bus: _path.arg("bus.svg")
    property string graph: _path.arg("graph.svg")
    property string home: _path.arg("home.svg")
    property string times: _path.arg("times.svg")
    property string user: _path.arg("user.svg")
    property string warning: _path.arg("warning.svg")
    property string bell: _path.arg("bell.svg")
    property string qrCode: _path.arg("qrCode.svg")
}
