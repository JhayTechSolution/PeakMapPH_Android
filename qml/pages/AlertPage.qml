import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Com.Plm.PeakMapPH 1.0
import "../"
import "../db"
import "../components"
import PeakMapPHApp
Item {
    function refreshAlerts(){
       readAlerts()
    }

    id: item
    Flickable{
        anchors.fill: parent
        contentHeight: mColumn.height
        ColumnLayout{
            id:mColumn
            width: parent.width
            Text{
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 16
                text:"Predictive Congestion Alerts"
                font.pixelSize: 20
                color:"white"
                font.weight: 700
                font.wordSpacing: 2
                font.letterSpacing: 1
            }
            Text{
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 16
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pixelSize: 16
                color:"white"
                text:"Customize thresholds for congestion levels and receive real-time notifications for potential bottlenecks"
            }

            Text{
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 24
                text:"Congestion Threshold"
                font.pixelSize: 18
                color:"white"
            }
            Repeater{
                id:congestionLive
                model: []
                delegate: RowLayout{
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 24
                    Layout.topMargin: 8
                    Layout.bottomMargin: 8
                    Rectangle{
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 4
                        color:"#353940"
                        AppIcon{
                            iconType: IconType.bello
                            color:"white"
                            anchors.centerIn: parent
                            size: 24
                        }
                    }
                    ColumnLayout{
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        Layout.alignment: Qt.AlignVCenter
                        Text{
                            property var level: modelData.level
                            text: "%1 Congestion Alert".arg( level[0].toUpperCase() + level.slice(1).toLowerCase())
                            color:"white"
                            font.weight: 600
                        }
                        Text{
                            text:"Potential Bottleneck detected on %1".arg(modelData.routeName)
                            color:"#d8d8d8"
                            font.pixelSize: 14
                        }
                    }


                }

            }


            Text{
                text:"Historical Alert Logs"
                font.pixelSize: 18
                Layout.topMargin: 24
                Layout.bottomMargin: 16
                font.weight: 700
                color:"white"
                Layout.leftMargin: 24

            }

            Repeater{
                id: historicalAlertLogs
                model: []
                delegate: RowLayout{
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 24
                    Layout.topMargin: 8
                    Layout.bottomMargin: 8
                    Rectangle{
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 4
                        color:"#353940"
                        AppIcon{
                            iconType: IconType.bello
                            color:"white"
                            anchors.centerIn: parent
                            size: 24
                        }
                    }
                    ColumnLayout{
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        Layout.alignment: Qt.AlignVCenter
                        Text{
                            property string level: modelData.level
                            text:"%1 Congestion Alert".arg(level[0].toUpperCase() + level.slice(1).toLowerCase())
                            font.pixelSize: 16
                            color:"white"
                            font.weight: 600
                        }
                        Text{
                            text:"Congestion on %1".arg(modelData.routeName)
                            color:"#d8d8d8"
                            font.pixelSize: 14
                        }
                    }

                }
            }


        }


    }

    AlertCongestion{
        id: alertCongestion
    }
    function readHistorical(startOnZero){
        ops.clear()
        ops.withField([
                      alertCongestion.routeName.columnName,
                      alertCongestion.level.columnName
                      ])
        ops.orderBy(alertCongestion.createdAt.columnName)
         ops.limit(20)
        if(startOnZero){
            ops.offset(0)
        }else{
             ops.offset(5);
        }
        ops.runQuery((data)=>{
            console.log('MODEL DATA ',JSON.stringify(data))
            historicalAlertLogs.model = []
            historicalAlertLogs.model = data
        }, true )
    }

    function readAlerts(){
        ops.instance(PeakMapConfig.db.useTable(alertCongestion.tableName))
        ops.withField([alertCongestion.routeName.columnName,
                      alertCongestion.level.columnName
                      ])
        ops.filter({
           "createdKey" : PeakMapConfig.formatDateNow()

        })
        ops.orderBy(alertCongestion.createdAt.columnName);
        ops.limit(5)
        ops.offset(0)
         ops.runQuery((data)=>{
             congestionLive.model = []
             congestionLive.model = data
            readHistorical()


        }, true)
        ops.clear()


    }
    Component.onCompleted: {
        readAlerts()
    }

    SQLiteOperation{
        id: ops
    }
}
