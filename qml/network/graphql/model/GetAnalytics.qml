import QtQuick 2.15
import "../"

CoreGraphQL{
    methodName: "getAnalytics"
    hasInput:true
    property alias analyticsType: analyticsInput.analyticsValue
    property alias timeRange: analyticsInput.timeValue
    queryInput: CoreInput{
        property var input:CoreInputMarker{
            dataType: "AnalyticsInput"
            value: AnalyticsInput{
                id: analyticsInput
            }

        }
    }
    noReturnObject: false
    queryResponse: AnalyticsResponseType{}
}
