import QtQuick 2.15
import "../"
CoreGraphQL{
    methodName: "getTodayBusActivity"
    graphqlType: GraphQLType.queryType
    hasInput: false
    noReturnObject: false
    queryResponse: BusActivity{}

}
