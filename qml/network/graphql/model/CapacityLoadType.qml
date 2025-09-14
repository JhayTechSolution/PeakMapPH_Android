import QtQuick 2.15
import "../"
CoreResponse{
    property CoreResponseMarker busId: CoreResponseMarker{
        dataType: CoreType.stringType
        include: true
    }
    property CoreResponseMarker maxPassengers:CoreResponseMarker{
        dataType: CoreType.intType
        include: true

    }
    property CoreResponseMarker currentPassengers: CoreResponseMarker{
        dataType: CoreType.intType
        include: true
    }
    property CoreResponseMarker busName: CoreResponseMarker{
        dataType: CoreType.stringType
        include: true
    }
}
