import QtQuick 2.15
import "../"
CoreGraphQL{
    methodName: "stationLoadUpdate"
    hasInput: false
    graphqlType: GraphQLType.subscriptionType
    noReturnObject: false
    queryResponse: StationLoad{}


}
