import QtQuick 2.15
import "../"
CoreInput{
    property alias bid: mBusId.value
    property alias lat: lat.value
    property alias lon:lon.value
    property alias actionType: mAction.value
    property var busId: CoreInputMarker{
        dataType: CoreType.stringType
        isRequired: true
        id: mBusId

    }
    property var location: CoreInputMarker{
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
    property var action: CoreInputMarker{
        dataType:"PassengerCountAction"
        isRequired: true
        id: mAction

    }
}
