import QtQuick 2.15
import "../"
CoreInput{
    property alias lat:latitude.value
    property alias lon: longitude.value
    property alias spd: currentSpeed.value
    property CoreInputMarker latitude: CoreInputMarker{
        dataType: CoreType.floatType
        isRequired: true
        id:  latitude
    }
    property CoreInputMarker longitude: CoreInputMarker{
        dataType: CoreType.floatType
        isRequired: true
        id: longitude
    }
    property CoreInputMarker currentSpeed: CoreInputMarker{
        dataType: CoreType.floatType
        isRequired: true
        id: currentSpeed
    }
}
