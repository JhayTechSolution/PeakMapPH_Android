import QtQuick 2.15

import "../"
CoreGraphQL{
    methodName: "clearBusActivity"
    graphqlType: GraphQLType.mutationType
    hasInput: true
    queryInput: CoreInput{
        property var busId: CoreInputMarker{
            dataType: CoreType.stringType
            isRequired: true
            id: busId
        }
    }
    noReturnObject: true
    property alias busId: busId.value
}
