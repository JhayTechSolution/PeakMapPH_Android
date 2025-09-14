import QtQuick 2.15
import "../"
CoreResponse{

    property CoreResponseMarker latitude: CoreResponseMarker{
        dataType: CoreType.floatType

    }

    property CoreResponseMarker longitude: CoreResponseMarker{
        dataType: CoreType.floatType
    }

    property CoreResponseMarker routeName: CoreResponseMarker{
        dataType: CoreType.stringType

    }




}
