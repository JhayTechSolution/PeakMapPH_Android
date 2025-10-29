import QtQuick 2.15

import "../"
CoreGraphQL{
    methodName: "getLocationName"
    graphqlType: GraphQLType.queryType
    hasInput: true
    queryInput: CoreInput{
        property var input:CoreInputMarker{
            dataType: "LocationInput"
            isRequired: true
             value:CoreInput{
                property var latitude: CoreInputMarker{
                    dataType: CoreType.floatType
                    isRequired: true
                    id: lat
                }
                property var longitude: CoreInputMarker{
                   dataType: CoreType.floatType
                   isRequired: true
                   id: lon
                }
            }
        }
    }
    noReturnObject: true
    property alias lat: lat.value
    property alias lon: lon.value
}
