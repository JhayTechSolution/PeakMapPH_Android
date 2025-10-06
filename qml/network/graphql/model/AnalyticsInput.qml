import QtQuick 2.15
import "../"

CoreInput{
    property string  analyticsType_RiderTrend:"RidersTrend"
    property string  analyticsType_PeakHours:"PeakHours"
    property string analyticsType_Bottleneck:"Bottleneck"

    property string timeType_Daily:"Daily"
    property string timeType_Weekly:"Weekly"
    property string timeType_Montly:"Monthly"
    property alias analyticsValue: antype.value
    property var analyticsType:CoreInputMarker{
        id: antype
        dataType: CoreType.stringType

    }
    property alias timeValue: tr.value
    property var timeRange:CoreInputMarker{
        id: tr
        dataType: CoreType.stringType
    }
}
