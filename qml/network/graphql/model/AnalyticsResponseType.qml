import QtQuick 2.15

import "../"
CoreResponse{
    property var record:CoreResponseMarker{
        dataType: CoreType.arrayOf(CoreType.stringType)
        include: true
    }
    property var value: CoreResponseMarker{
        dataType:CoreType.arrayOf(CoreType.floatType)
        include:true
    }
    property var changes: CoreResponseMarker{
        dataType:CoreType.intType
        include: true
    }
}
