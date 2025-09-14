import QtQuick 2.15
import "../"
import Com.Plm.PeakMapPH
CoreGraphQL{
    methodName: "getCurrentBusCapacityLoad"
    hasInput: true
    property alias busId: coreInput.value
    queryInput: CapacityLoadInput{ id : coreInput }
    queryResponse: CapacityLoadType{}

}
