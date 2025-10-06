import QtQuick 2.15

import "../"
CoreGraphQL{
    graphqlType: GraphQLType.subscriptionType
    methodName:"congestionUpdate"
    hasInput: false
    queryResponse: CongestionResponseModel{}
}
