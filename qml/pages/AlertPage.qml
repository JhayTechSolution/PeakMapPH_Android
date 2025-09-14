import QtQuick
import Felgo
import QtQuick.Layouts
import QtQuick.Controls
Item {

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
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color:"#2c2f36" //correct?
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 8
                radius: 8
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 8
                Rectangle{
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 4
                    color:"#353940"
                    AppIcon{
                        iconType: IconType.bello
                        color:"white"
                        anchors.centerIn: parent

                    }

                }
                ColumnLayout{
                    Layout.fillWidth: true
                    Layout.leftMargin: 8
                    Layout.alignment: Qt.AlignVCenter
                   Text{
                       text:"High Congestion Alert"
                       font.pixelSize: 16
                       color:"white"
                       font.weight: 600
                   }
                   Text{

                       text:"Potential Bottleneck detected on Route 101"
                       color:"#d8d8d8"
                       font.pixelSize: 14
                   }
                }
            }
            Item{
                Layout.preferredHeight: 8
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 8
                Rectangle{
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 4
                    color:"#353940"
                    AppIcon{
                        iconType: IconType.bello
                        color:"white"
                        anchors.centerIn: parent

                    }

                }
                ColumnLayout{
                    Layout.fillWidth: true
                    Layout.leftMargin: 8
                    Layout.alignment: Qt.AlignVCenter
                   Text{
                       text:"Medium Congestion Alert"
                       font.pixelSize: 16
                       color:"white"
                       font.weight: 600
                   }
                   Text{

                       text:"Potential Bottleneck detected on Route 202"
                       color:"#d8d8d8"
                       font.pixelSize: 14
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
            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 8
                Rectangle{
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 4
                    color:"#353940"
                    AppIcon{
                        iconType: IconType.bello
                        color:"white"
                        anchors.centerIn: parent

                    }

                }
                ColumnLayout{
                    Layout.fillWidth: true
                    Layout.leftMargin: 8
                    Layout.alignment: Qt.AlignVCenter
                   Text{
                       text:"High Congestion Alert"
                       font.pixelSize: 16
                       color:"white"
                       font.weight: 600
                   }
                   Text{

                       text:"Congestion on Route 101"
                       color:"#d8d8d8"
                       font.pixelSize: 14
                   }
                }
            }
            Item{
                Layout.preferredHeight: 8
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 8
                Rectangle{
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 4
                    color:"#353940"
                    AppIcon{
                        iconType: IconType.bello
                        color:"white"
                        anchors.centerIn: parent

                    }

                }
                ColumnLayout{
                    Layout.fillWidth: true
                    Layout.leftMargin: 8
                    Layout.alignment: Qt.AlignVCenter
                   Text{
                       text:"Medium Congestion Alert"
                       font.pixelSize: 16
                       color:"white"
                       font.weight: 600
                   }
                   Text{

                       text:"Congestion on Route 202"
                       color:"#d8d8d8"
                       font.pixelSize: 14
                   }
                }
            }

        }


    }

}
