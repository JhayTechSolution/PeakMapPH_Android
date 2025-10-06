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
import "components"
import QtCore
ApplicationWindow{
    id:root

    width: (Qt.platform.os !== "android")?480: -1
    height: (Qt.platform.os !== "android") ? 800: -1


    LocationPermission{

        id: locationPermision
        onStatusChanged: {
            if(status !== Qt.Granted){
                request()
                return
            }
            PeakMapConfig.initConfig()
            PeakMapConfig.gtransport.connectServer()
            PeakMapConfig.gtransport.connectionOkay.connect(()=>{
                baua.subscribe()
                stationLoad.subscribe()
                cus.subscribe()
                tsu.sendRequest((c,x)=>{})
                mDashboard.startLoad()
                mReportPage.startLoad()
            })
        }
    }

    function calledBack(){
        swipePage.focus=true
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
        height:60
        RowLayout{
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: parent.width
            x: 10
            id:mRowHeader

            Item{
                Layout.preferredWidth: mRowHeader.width
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 40
                id:mContainerTitle
                RowLayout{
                    anchors.fill: parent
                    Item{
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: 40
                        AppIcon{
                            anchors.centerIn: parent
                            iconType: IconType.user
                            color: "white"
                            size: 24
                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    parent.opacity=0.6
                                }
                                onReleased: {
                                    parent.opacity=1
                                    loginPage.open()
                                }
                            }
                        }
                    }

                    AppText{
                        id: headerTitle
                        text:"Dashboard"
                        color:"white"
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter


                        font.pixelSize: 20
                        font.weight: 600
                    }
                    Item{
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 40
                    }


                }


            }

        }
    }




    SwipeView{
        id: swipePage
        anchors.fill: parent
        currentIndex: tabIndex
        interactive: false
        focus: true
        onFocusChanged: {
            if(!focus){
                focus = true
            }

        }

        Keys.onBackPressed: {
            if(loginPage.opened){
                loginPage.close()
                return
            }
            exitConfirm.open()

        }

        DashboardPage{
            id: mDashboard
            onUpdateAlerts: {
                mAlertPage.refreshAlerts()
            }

        }
        ReportPage{
            id: mReportPage
        }
        AlertPage{
            id:mAlertPage

        }
        AboutPage{

        }


    }


    footer:  ToolBar{
        height:80
        background: Rectangle{
            color:"black"
        }
        leftPadding:10
        rightPadding: 10
        topPadding: 5
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
                        iconType: IconType.graph

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
                    property SQLiteOperation dbOperation: SQLiteOperation{

                    }  AppIcon{
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
                        iconType: IconType.infoCircle

                        color: (tabIndex===3) ? "white":"#353940"
                        size:24
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text{
                        Layout.alignment: Qt.AlignHCenter
                        text:"About"
                        font.pixelSize: 14

                        color: (tabIndex===3) ? "white":"#353940"
                    }
                }
                 onClicked :  {tabIndex = 3; headerTitle.text = "About" }
            }


        }

    }

    Component.onCompleted: {
       locationPermision.statusChanged()



    }

    BusActivityUpdateAll{
        id:  baua
        dataItem: Component{
            BusActivity{
                id: bus
                onCaptureData: {
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


    StationLoadUpdateSubscription{
        id :stationLoad
        onArrayReturn: (data)=>{
            mDashboard.sendLoadRank(data)

        }

    }
    TriggerStationUpdate{
        id: tsu

    }

    CongestionUpdateSubscription{
        id: cus
        onArrayReturn: (data)=>{
            mDashboard.addHeatMap({
                target: {
                    latitude: data.latitude,
                    longitude: data.longitude
                },
                congestion: data.level
            })
            if(data.level === "LOW"){
                return
            }

            ops.instance(PeakMapConfig.db.useTable(ac.tableName));
            data[ac.createdAt.columnName] = Date.now()
            data[ac.createdKey.columnName] = PeakMapConfig.formatDateNow()
            ops.insert(data)


            mAlertPage.refreshAlerts()
        }

    }

    AlertCongestion{
        id: ac
    }

    SQLiteOperation{
        id: ops

    }

    Drawer{
        id: loginPage
        parent:Overlay.overlay
        width: parent.width
        height: parent.height
        background: Rectangle{
            color:"#222222"
        }
        interactive: false
        edge: Qt.BottomEdge
        focus:false
        onFocusChanged: {
            if(!focus){
                if(loginPage.opened){
                    focus= true
                }
            }
        }

        LoginPage{
            anchors.fill: parent
            onCloseRequest: {
                loginPage.close()
            }
        }
        onAboutToHide: {
            swipePage.focus = true
        }
        Keys.onBackPressed: {
            if(opened){
                loginPage.close()
            }
        }

   }


    Popup{
        id: exitConfirm
        modal:true
        parent: Overlay.overlay
        width: parent.width
        height: parent.height
        background:Rectangle{
            opacity:0.5
        }

        leftPadding: 24
        rightPadding: 24
        Frame{
            anchors.centerIn: parent
            width: parent.width - 48
            height: 100
            background: Rectangle{
                radius: 10
            }

            ColumnLayout{
                anchors.fill: parent
                Item{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Text{
                        anchors.centerIn: parent
                        text:"Are you sure that you want to quit?"
                    }
                }
                Item{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    RowLayout{
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        Button{
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 35
                            text:"No"
                            onClicked: {
                                exitConfirm.close()
                            }

                        }
                        Button{
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 80
                            text:"Yes"
                            onClicked:{
                                exitConfirm.close()
                                Qt.exit(1)
                            }
                        }
                        Item{
                            Layout.preferredWidth: 24
                        }
                    }
                }
            }
        }
    }



}
