import QtQuick 2.15
import "../"

CoreGraphQL{
    methodName: "busActivityUpdateAll"
    graphqlType:GraphQLType.subscriptionType
    hasInput: false
    noReturnObject: false
    queryResponse: BusActivity{
        lastSavedLocation.include: false
    }
}
