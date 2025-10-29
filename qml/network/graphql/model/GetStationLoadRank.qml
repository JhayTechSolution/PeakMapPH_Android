import QtQuick 2.15
import "../"
CoreGraphQL{
    methodName: "getStationLoadRank"
    hasInput: false
    graphqlType: GraphQLType.queryType
    noReturnObject: false
    queryResponse: StationLoad{}


}
