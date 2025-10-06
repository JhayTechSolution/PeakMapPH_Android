import QtQuick 2.15

import "../"
CoreResponse{
    property var level:CoreResponseMarker{
        dataType:CoreType.stringType
        include: true
    }
    property var routeName:CoreResponseMarker{
        dataType: CoreType.stringType
        include:true
    }
    property var latitude: CoreResponseMarker{
        dataType: CoreType.floatType
        include: true

    }
    property var longitude: CoreResponseMarker{
        dataType: CoreType.floatType
        include: true
    }
}
