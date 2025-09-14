import QtQuick 2.15
import "../"
CoreGraphQL{
methodName: "getBusName"
hasInput:true
noReturnObject: true
property alias busId: capInput.value
queryInput: CapacityLoadInput{
    id: capInput
}


}
