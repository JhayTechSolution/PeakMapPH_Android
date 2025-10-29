import QtQuick
import "../components"
import QtQuick.Layouts
import QtQuick.Controls
import "../fragments"
import "../network/graphql/model"
Item {
    function startLoad(){

        if(ridersTrendLoaded === false && peakHoursLoaded === false && bottleneckLoaded === false){
            loadedChanged()
        }

        ridersTrendLoaded=false
        peakHoursLoaded = false
        bottleneckLoaded = false
        ridershipAnalytics.sendRequest((s,e)=>{})
        peakhoursAnalytics.sendRequest((s,e)=>{})
        bottleneckAreas.sendRequest((s,e)=>{})
    }

    property string timeRange:mRepeater.model[selectIndex]
    onTimeRangeChanged: {
        startLoad()
    }

    id: item
    property int selectIndex:0

    Flickable{
        anchors.fill: parent
        contentHeight: mContent.height
        ColumnLayout{
            id:mContent
            width: parent.width
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color:"#3A4650"
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 16
                radius: 8
                RowLayout{
                    anchors.fill: parent
                    Repeater{
                        model:["Daily", "Weekly","Monthly"]
                        id:mRepeater
                        delegate: Rectangle{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.margins: 10
                            radius: 8
                            color: (selectIndex === index) ? "black":"transparent"
                            Text{
                                text:modelData
                                font.pixelSize: 18
                                anchors.centerIn: parent
                                color:"white"
                                font.weight: (selectIndex === index)? 700:500
                            }

                            MouseArea{
                                anchors.fill: parent

                                onClicked:{
                                    selectIndex = index
                                }
                            }
                        }
                    }
                }
            }

            Frame{
                Layout.fillWidth: true

                Layout.preferredHeight: 450
                Layout.leftMargin: 24
                Layout.topMargin: 16
                Layout.rightMargin: 24
                topPadding:24
                leftPadding:16
                rightPadding:16
                bottomPadding:24
                background:Rectangle{
                    color:"transparent"
                    border.width: 1
                    radius: 8
                    border.color: "#383838"
                }
                ColumnLayout{
                    anchors.fill: parent
                    Text{
                        text:"Ridership Trend"
                        color:"white"
                        font.pixelSize: 16
                        font.weight: 600
                    }
                    Text{
                        text:"%1%".arg(ridersTrend.change)
                        font.pixelSize: 30
                        color:"white"
                        font.weight: 900
                    }
                    Text{
                        text: {

                            if(selectIndex === 0){
                               return "Last 7 days <m style='color:%1'>%2%</m>".arg(ridersTrend.indicatorColor).arg(ridersTrend.change)
                            }else if(selectIndex === 1){
                               return "Last 6 weeks <m style='color:%1'>%2%</m>".arg(ridersTrend.indicatorColor).arg(ridersTrend.change)
                            }else if(selectIndex === 2){
                                return "Last 5 months <m style='color:%1'>%2%</m>".arg(ridersTrend.indicatorColor).arg(ridersTrend.change)
                            }

                        }
                        font.pixelSize: 14
                        color:"#888888"
                        textFormat: Text.MarkdownText
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        ChartScreen{
                            id:ridersTrend

                            property int change

                            property string indicatorColor: (change < 0) ? "#FF073A": "#39FF14"
                            chartLabels: []
                            hasLabelY: false
                            gridLinesColor: "#00000000"
                            dataBackgroundColor: "#585858"
                            dataBorderColor: "#FFFFFF"
                            chartStyle: ChartScreen.ChartType.Line
                        }
                    }
                }

            }

            Frame{
                Layout.fillWidth: true
                Layout.preferredHeight: 350
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 16

                topPadding:24
                leftPadding:16
                rightPadding:16
                bottomPadding:24
                background:Rectangle{
                    color:"transparent"
                    border.width: 1
                    border.color: "#383838"
                    radius:8
                }
                ColumnLayout{
                    anchors.fill: parent
                    Text{
                        text:"Peak Hours"
                        font.pixelSize:16
                        font.weight: 600
                        color:"white"
                    }
                    Text{
                        text:"%1%".arg(peakHours.change)
                        font.pixelSize: 30
                        font.weight: 900
                        color:"white"
                    }
                    Text{
                        text: {

                            if(selectIndex === 0){
                               return "Last 7 days <m style='color:%1'>%2%</m>".arg(peakHours.indicatorColor).arg(peakHours.change)
                            }else if(selectIndex === 1){
                               return "Last 6 weeks <m style='color:%1'>%2%</m>".arg(peakHours.indicatorColor).arg(peakHours.change)
                            }else if(selectIndex === 2){
                                return "Last 5 months <m style='color:%1'>%2%</m>".arg(peakHours.indicatorColor).arg(peakHours.change)
                            }

                        }
                        font.pixelSize: 14
                        color:"#888888"
                        textFormat: Text.MarkdownText
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        ChartScreen{

                            property int change

                            property string indicatorColor: (change < 0) ? "#FF073A": "#39FF14"
                            id: peakHours
                            chartLabels: []
                            hasLabelY: false
                            gridLinesColor: "#00000000"
                            dataBackgroundColor: "#585858"
                            dataBorderColor: "#FFFFFF"
                            chartStyle: ChartScreen.ChartType.Bar
                        }
                    }
                }
            }
            Frame{
                Layout.fillWidth: true
                Layout.preferredHeight: 600
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 16

                topPadding:24
                leftPadding:16
                rightPadding:16
                bottomPadding:24
                background:Rectangle{
                    color:"transparent"
                    border.width: 1
                    border.color: "#383838"
                    radius:8
                }
                ColumnLayout{
                    anchors.fill: parent
                    Text{
                        text:"Bottleneck Areas"
                        font.pixelSize:16
                        font.weight: 600
                        color:"white"
                    }
                    Text{
                        text:"%1%".arg(bottleneck.change)
                        font.pixelSize: 30
                        font.weight: 900
                        color:"white"
                    }
                    Text{

                        text: {

                            if(selectIndex === 0){
                               return "Last 7 days <m style='color:%1'>%2%</m>".arg(bottleneck.indicatorColor).arg(bottleneck.change)
                            }else if(selectIndex === 1){
                               return "Last 6 weeks <m style='color:%1'>%2%</m>".arg(bottleneck.indicatorColor).arg(bottleneck.change)
                            }else if(selectIndex === 2){
                                return "Last 5 months <m style='color:%1'>%2%</m>".arg(bottleneck.indicatorColor).arg(bottleneck.change)
                            }

                        }
                        font.pixelSize: 14
                        color:"#888888"
                        textFormat: Text.MarkdownText
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        ChartScreen{
                            property int change

                            property string indicatorColor: (change < 0) ? "#FF073A": "#39FF14"
                            id: bottleneck
                            chartLabels: []
                            hasLabelX:false
                            gridLinesColor: "#00000000"
                            dataBackgroundColor: "#585858"
                            dataBorderColor: "#FFFFFF"
                            chartStyle: ChartScreen.ChartType.HorizontalBar
                       //     onChartTypeChanged:

                        }
                    }

                }
            }

        }
    }

    GetAnalytics{
        id: ridershipAnalytics
        analyticsType: "RidersTrend"
         timeRange: mRepeater.model[selectIndex]
         dataItem: Component{
             AnalyticsResponseType{
                 id: rAnalytics
                 onCaptureData: {
                     ridersTrend.chartLabels=[]
                     ridersTrend.dataSets=[]

                     ridersTrend.chartLabels= rAnalytics.record.value
                     var ds = []
                    ridersTrend.change = rAnalytics.changes.value
                     ds.push(rAnalytics.value.value)
                     ridersTrend.dataSets=ds
                     Qt.callLater(()=>{

                                      ridersTrendLoaded = true
                    })
                 }
             }
         }
         onDelegateReturn: (c)=>c.captureData()
    }
    GetAnalytics{
        id: peakhoursAnalytics
        analyticsType: "PeakHours"
      timeRange: mRepeater.model[selectIndex]
         dataItem: Component{
             AnalyticsResponseType{
                 id: rAnalytics
                 onCaptureData: {
                     peakHours.chartLabels=[]
                     peakHours.dataSets= []
                    peakHours.chartLabels = rAnalytics.record.value
                    let ds =[]
                     ds.push(rAnalytics.value.value)
                     peakHours.change = rAnalytics.changes.value
                     peakHours.dataSets=ds
                     Qt.callLater(()=>{

                                      peakHoursLoaded =true
                    })
                 }
             }
         }
         onDelegateReturn: (c)=>c.captureData()

    }
    GetAnalytics{
        id: bottleneckAreas
        analyticsType: "Bottleneck"
        timeRange: mRepeater.model[selectIndex]
         dataItem: Component{
             AnalyticsResponseType{
                 id: rAnalytics
                 onCaptureData: {
                     bottleneck.chartLabels=[]
                     bottleneck.dataSets=[]
                     var ds = []
                    bottleneck.chartLabels = rAnalytics.record.value
                     ds.push(rAnalytics.value.value)
                     bottleneck.dataSets= ds
                     bottleneck.change = rAnalytics.changes.value

                     Qt.callLater(()=>{

                                      bottleneckLoaded = true
                    })
                 }
             }
         }
         onDelegateReturn: (c)=>c.captureData()
    }
    Component.onCompleted: {
    }
    property bool ridersTrendLoaded:false
    property bool peakHoursLoaded: false
    property bool bottleneckLoaded: false
    property bool loaded: ridersTrendLoaded && peakHoursLoaded && bottleneckLoaded
    onLoadedChanged: {
        if(loaded){
            loader.close()
        }
        else{
            Qt.callLater(()=>{
                loader.open()
            })
        }
    }

    onVisibleChanged: {
        console.log("VISIBLE CHANGED")
    }
    Loading{
        id: loader
    }

}
