import Felgo
import QtQuick
import QtPositioning
import QtLocation
import QtQuick.Layouts
import QtQuick.Controls
import QtCharts
import "pages"
import "../qml" as P
import "db"
import Com.Plm.PeakMapPH
import "../qml/network/graphql/model"
ApplicationWindow{
    id:root
    width: (Qt.platform.os !== "android")?480: -1
    height: (Qt.platform.os !== "android") ? 800: -1
    App{
        visible:false
        onVisibilityChanged: {
            Qt.callLater(()=>{
            if(visible){
                visible=false

            }
            })
            app.width=-1
            app.height=-1
            app.close()
        }
        id: app

    }
    function getApplication(){
        return root
    }

    function dp(x){
        return app.dp(x)
    }
    flags: Qt.Window | Qt.WindowStaysOnTopHint
    property int tabIndex: 0
    title:"Peak Map PH"
    visible:true
    background: Rectangle{
        color:"#222222"
    }

    header: Rectangle{
        color:"black"
        height:80
        RowLayout{
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: parent.width
            y:10
            x: 10
            id:mRowHeader
            Item{
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40

                IconButton{
                    iconType: IconType.bars
                    color:"white"
                    size:24
                    anchors.centerIn:parent
                }
            }
            Item{
                Layout.preferredWidth: mRowHeader.width - 100
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 40
                id:mContainerTitle
                AppText{
                    id: headerTitle
                    text:"Dashboard"
                    color:"white"
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter

                    rightPadding: 60
                    font.pixelSize: 20
                    font.weight: 600
                }


            }

        }
    }
    SwipeView{
        anchors.fill: parent
        currentIndex: tabIndex
        interactive: false
        DashboardPage{
            id: mDashboard
        }
        ReportPage{}
        AlertPage{}


    }

    footer:  ToolBar{
        height:120
        background: Rectangle{
            color:"black"
        }
        leftPadding:10
        rightPadding: 10
        topPadding: 5
        bottomPadding:5
        RowLayout{
            width: parent.width
            height: 60
            anchors.top: parent.top
            anchors.topMargin: 10
            spacing: 6
            ToolButton{
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Item{}

                ColumnLayout{
                    anchors.fill: parent
                    AppIcon{
                        iconType: IconType.home
                        color: (tabIndex===0) ? "white":"#353940"
                        size:24
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text{
                        Layout.alignment: Qt.AlignHCenter
                        text:"Dashboard"
                        font.pixelSize: 14

                        color: (tabIndex===0) ? "white":"#353940"
                    }
                }
                onClicked: { tabIndex =0; headerTitle.text="Dashboard"; }
            }
            ToolButton{
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Item{}
                ColumnLayout{
                    anchors.fill: parent
                    AppIcon{
                        iconType: IconType.linechart

                        color: (tabIndex===1) ? "white":"#353940"
                        size:24
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text{
                        Layout.alignment: Qt.AlignHCenter
                        text:"Reports"
                        font.pixelSize: 14

                        color: (tabIndex===1) ? "white":"#353940"
                    }
                }
                onClicked: { tabIndex = 1; headerTitle.text="Reports"; }

            }
            ToolButton{
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Item{}
                ColumnLayout{
                    anchors.fill: parent
                    AppIcon{
                        iconType: IconType.bell

                        color: (tabIndex===2) ? "white":"#353940"
                        size:24
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text{
                        Layout.alignment: Qt.AlignHCenter
                        text:"Alerts"
                        font.pixelSize: 14

                        color: (tabIndex===2) ? "white":"#353940"
                    }

                }
                onClicked:  {tabIndex = 2; headerTitle.text = "Alerts"; }

            }

            ToolButton{
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Item{}
                ColumnLayout{
                    anchors.fill: parent
                    AppIcon{
                        iconType: IconType.gear

                        color: (tabIndex===3) ? "white":"#353940"
                        size:24
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text{
                        Layout.alignment: Qt.AlignHCenter
                        text:"Settings"
                        font.pixelSize: 14

                        color: (tabIndex===3) ? "white":"#353940"
                    }
                }
                 onClicked :  {tabIndex = 3 }
            }


        }

    }

    Component.onCompleted: {

        PeakMapConfig.initConfig()
        PeakMapConfig.gtransport.connectServer()
        PeakMapConfig.gtransport.connectionOkay.connect(()=>{
            baua.subscribe()
        })
    }

    BusActivityUpdateAll{
        id:  baua
        dataItem: Component{
            BusActivity{
                id: bus
                onCaptureData: {
                    console.log(JSON.stringify(bus.currentLocation.resultObject))
                    mDashboard.sendBusActivity(bus.busId.value,
                                               {
                                                 latitude : bus.currentLocation.resultObject.latitude.value,
                                                 longitude: bus.currentLocation.resultObject.longitude.value
                                               },
                                               bus.congestionLevel.value)
                }
            }
        }
        onDelegateReturn:  (c)=> c.captureData()
    }



}
