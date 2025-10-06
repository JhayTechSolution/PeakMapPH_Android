import QtQuick 2.15
import "../"
CoreResponse{

    property CoreResponseMarker latitude: CoreResponseMarker{
        dataType: CoreType.floatType
        include:true
    }

    property CoreResponseMarker longitude: CoreResponseMarker{
        dataType: CoreType.floatType
        include:true
    }

    property CoreResponseMarker routeName: CoreResponseMarker{
        dataType: CoreType.stringType
        include:true

    }




}
