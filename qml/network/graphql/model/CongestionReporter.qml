import QtQuick 2.15

import "../"
CoreGraphQL{
    property alias lat: qi.lat


    property alias lon: qi.lon
    property alias speed: qi.spd
    methodName: "reportCurrentCongestion"
    graphqlType: GraphQLType.mutationType
    hasInput: true
    queryInput:CoreInput{
        property var input:CoreInputMarker{
            dataType: "CongestionReporterInput"
            value:  CongestionReporterInput{
                id: qi
            }
        }
    }

    noReturnObject: true

}
