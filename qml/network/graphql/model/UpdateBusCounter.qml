import QtQuick 2.15
import "../"
CoreGraphQL{
    methodName: "updateBusCounter"
    graphqlType: GraphQLType.mutationType
    hasInput: true
    queryInput: CoreInput{
        property var input: CoreInputMarker{
            dataType: "BusCounterInput"
            isRequired: true
            value:BusCounterInput{
                id: bci
            }
        }
    }
    noReturnObject: true
    property alias busId : bci.bid
    property alias lat: bci.lat
    property alias lon : bci.lon
    property alias action: bci.actionType
}
