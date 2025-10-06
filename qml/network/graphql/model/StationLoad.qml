import QtQuick 2.15
import "../"
CoreResponse{
    property var stationName:CoreResponseMarker{
        dataType: CoreType.stringType
        include: true
    }
    property var passengerCount:CoreResponseMarker{
        dataType: CoreType.intType
        include: true
    }
}
