import QtQuick

import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../"
Rectangle{
    anchors.fill: parent
    color:"#222222"


    signal closeRequest()
    PaddedRectangle{
        color:"#00000000"
        anchors.right: parent.right
        rightPadding: 24
        width: 48
        height: 30
        AppIcon{
            size: 24
            iconType: IconType.times
            color:"white"
            anchors.centerIn: parent
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    closeRequest()
                }
            }


        }

    }

    ColumnLayout{

        width: parent.width
        anchors.centerIn: parent
        spacing: 24

        Image{
            Layout.alignment: Qt.AlignHCenter
            source:"../../assets/peakmap.webp"
        }

        Rectangle{
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 10
            color:"#05FFFFFF"
            RowLayout{
                anchors.centerIn: parent
                spacing: 24
                AppIcon{
                    size: 24
                    iconType: IconType.warning
                    color:"white"
                }

                Text{
                    text:"Login for drivers only"
                    font.pixelSize:18
                    color:"white"
                }
            }
        }

        TextField{
            Layout.leftMargin:24
            Layout.rightMargin:24
            Layout.fillWidth:true
            Layout.preferredHeight: 60
            background:Rectangle{
                color:"#05FFFFFF"
                radius: 10
            }
            leftPadding:24
            rightPadding: 24
            color:"white"
            placeholderText:"Username"
            placeholderTextColor:"#888888"
        }

        TextField{
            Layout.leftMargin:24
            Layout.rightMargin:24
            Layout.fillWidth:true
            Layout.preferredHeight: 60
            background:Rectangle{
                color:"#05FFFFFF"
                radius: 10
            }
            leftPadding:24
            rightPadding: 24
            color:"white"
            echoMode:TextInput.Password
            placeholderText:"Password"
            placeholderTextColor:"#888888"
        }

        Button{
            Layout.leftMargin:24
            Layout.rightMargin: 24
            Layout.fillWidth:true
            Layout.preferredHeight:60
            background:Rectangle{
                color:"#10FFFFFF"
                radius: 10
            }
            text:"LOGIN"
            contentItem: Text{
                text: parent.text
                anchors.fill: parent
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color:"white"
                font.pixelSize:20
                font.weight:500
            }

        }

    }
    PaddedRectangle{
        color:"#00000000"
        anchors.bottom: parent.bottom
        width: parent.width
        height: 30
        Text{
            text:"v%1".arg(PeakMapConfig.version)
            anchors.centerIn: parent
            color:"#a8a8a8"
            font.pixelSize: 14

        }
    }
}
