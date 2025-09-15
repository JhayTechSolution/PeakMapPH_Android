import QtQuick 2.15
import "../"
CoreGraphQL{
     methodName: "busActivityUpdate"
     hasInput: true
     noReturnObject: false
     property alias busId: capLoad.value
     queryInput: CapacityLoadInput{
        id: capLoad
     }
     queryResponse: CapacityLoadType{

     }
     graphqlType: GraphQLType.subscriptionType
}
