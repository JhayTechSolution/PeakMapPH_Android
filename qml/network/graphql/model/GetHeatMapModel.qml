import QtQuick 2.15

import "../"

CoreResponse{
    property var routeName: CoreResponseMarker{
        dataType:CoreType.stringType
        include:true

    }

    property var target: CoreResponseMarker{
        dataType: "HeatMapPoint"
        include:true
        resultObject: LocationPointType{
            routeName.include: false
        }

    }
    property var congestion: CoreResponseMarker{
        dataType: CoreType.stringType
        include: true
    }

}
