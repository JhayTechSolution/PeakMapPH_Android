import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore
import "./components"
import "./pages"
import  PeakMapPHApp
import Com.Plm.PeakMapPH

ApplicationWindow{
    id:root

    width: (Qt.platform.os !== "android")?480: -1
    height: (Qt.platform.os !== "android") ? 800: -1





    flags: Qt.Window | Qt.WindowStaysOnTopHint
    property alias tabIndex: swipeSession.currentIndex
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
                            visible: PeakMapConfig.login_user !== ""
                            anchors.centerIn: parent
                            iconType: IconType.logout
                            color: "white"
                            size: 24
                            MouseArea{
                                anchors.fill: parent
                                onPressed:{
                                    parent.opacity = 0.6
                                }
                                onReleased:{
                                    parent.opacity = 1
                                    confirmLogout.open()

                                }
                            }
                        }

                        AppIcon{
                            visible: PeakMapConfig.login_user == ""
                            anchors.centerIn: parent
                            iconType:   IconType.user
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


    SwipeSessionView{
        id: swipeSession
        anchors.fill: parent
        currentIndex:  tabIndex
        Keys.onPressed: {
            console.log('key3')
        }

    }




    footer:  ToolBar{
        visible: PeakMapConfig.id === "" || PeakMapConfig.login_user===""
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
                        iconType:  IconType.bell

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
        IconType.init()
        PeakMapConfig.initConfig()
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

        LoginPage{
            anchors.fill: parent
            onCloseRequest: {
                loginPage.close()
            }
            onLoginSuccessful:{
                loginPage.close()
                swipeSession.reloadView()
                headerTitle.text= "Peakmap Driver App"
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

    ConfirmationBox{
        width: parent.width
        height: parent.height
        message: "Do you want to logout from the system ?"
        onOkCallback: {

            close()
            try{
                 PeakMapConfig.login_user = ""
                 PeakMapConfig.id= ""
                 PeakMapConfig.role = ""
                 PeakMapConfig.fullName = ""
                PeakMapConfig.currentBusName = ""
                PeakMapConfig.currentBusId = ""
                PeakMapConfig.currentPassenger =0
                PeakMapConfig.busId = ""
                PeakMapConfig.busName= ""
                PeakMapConfig.maxPassenger = 0
                console.log('service cleared')
               root.tabIndex= 0
                Qt.callLater(()=>{
                    swipeSession.reloadView()

                })
            }catch(err){
                console.log(err)
            }
        }
        id: confirmLogout
        title: "Confirm action"
    }



}

