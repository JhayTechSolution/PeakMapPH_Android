import QtQuick 2.15
import "../"

CoreResponse{
    property CoreResponseMarker busId: CoreResponseMarker{
        dataType: CoreType.stringType
        include: true

    }
    property CoreResponseMarker lastSavedLocation: CoreResponseMarker{
        dataType: "LocationPoint"
        include:true
        resultObject: LocationPointType{
            routeName.include: false
        }

    }
    property CoreResponseMarker currentLocation: CoreResponseMarker{
        dataType:"LocationPoint"
        include: true
        resultObject: LocationPointType{
            routeName.include: false
        }
    }

    property CoreResponseMarker passengerCount: CoreResponseMarker{
        dataType: CoreType.intType
        include: true
    }
    property CoreResponseMarker congestionLevel: CoreResponseMarker{
        dataType: CoreType.stringType
        include: true
    }

}
