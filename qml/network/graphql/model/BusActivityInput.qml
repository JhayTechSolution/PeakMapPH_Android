import QtQuick 2.15
import "../"
CoreInput{
    property alias bid: busId.value
    property alias lat: lat.value
    property alias lon:lon.value
    property alias passengers: passengerCount.value
    property var busId: CoreInputMarker{
        dataType: CoreType.stringType
        isRequired: true
        id: busId
    }
    property var currentLocation: CoreInputMarker{
        dataType: "LocationInput"
        isRequired: true
        value:CoreInput{

            property var latitude: CoreInputMarker{
                dataType: CoreType.floatType
                isRequired: true
                id: lat
            }
            property var longitude: CoreInputMarker{
                dataType: CoreType.floatType
                isRequired: true
                id: lon
            }
        }
    }
    property var passengerCount: CoreInputMarker{
        dataType:CoreType.intType
        isRequired: true
        id: passengerCount
    }
}
