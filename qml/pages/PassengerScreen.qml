import QtQuick
import QtQuick.Controls
import QtCore
import QtQuick.Layouts

import QtCharts
import "pages"
import "../qml" as P
import "db"
import Com.Plm.PeakMapPH
import "../qml/network/graphql/model"
import "components"
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
    Component.onCompleted: {
       locationPermision.statusChanged()



    }

}
