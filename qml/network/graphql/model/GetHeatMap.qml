import QtQuick 2.15

import "../"
CoreGraphQL{
    methodName: "getHeatMap"
    hasInput: false
    queryResponse: GetHeatMapModel{}
}
