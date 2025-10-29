import QtQuick 2.15
import "../"

CoreGraphQL{
    methodName: "createBusActivity"
    hasInput: true
    graphqlType: GraphQLType.mutationType
    noReturnObject: true
    queryInput: CoreInput{
        property var input: CoreInputMarker{
            dataType: "BusActivityInput"
            isRequired: true
            value: BusActivityInput{
                id: bai
            }
        }
    }

    property alias busId: bai.bid
    property alias lat: bai.lat
    property alias lon: bai.lon
    property alias passengerCount: bai.passengers
}
