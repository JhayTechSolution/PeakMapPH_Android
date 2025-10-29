import QtQuick

import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../"
import "../fragments"
import "../network/graphql/model"
Rectangle{
    signal loginSuccessful()
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
            id: username
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
            id: password
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
            onClicked: {
                loader.open()
                loginRequest.username = username.text
                loginRequest.password = password.text
                loginRequest.sendRequest((s,e)=>{
                                         loader .close()
                                         })
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
    Loading{
        id: loader
        width: parent.width
        height: parent.height
    }

    LoginRequest{
        id: loginRequest
        dataItem: AccountInfo{
            id: account
             onCaptureData: {

                 let role_type = account.role.value

                 if(role_type !== "DRIVER"){
                     mAlertBox.title="Failed to login"
                     mAlertBox.message ="You are not allowed to login"
                     mAlertBox.open()
                     return
                 }

                 PeakMapConfig.login_user =account.username.value
                 PeakMapConfig.id= account.accountId.value
                 PeakMapConfig.role = account.role.value
                 PeakMapConfig.fullName = account.fullName.value
                loginSuccessful()
             }
        }
        onDelegateReturn: (d)=>d.captureData()
    }
    AlertBox{
        id: mAlertBox
        width: parent.width
        height: parent.height
    }
    Keys.onPressed: {
        console.log('key login')
    }
}
