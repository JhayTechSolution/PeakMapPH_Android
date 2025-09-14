import QtQuick
import Felgo
import QtQuick.Layouts
import QtQuick.Controls
import QtLocation
import QtPositioning
import Qt5Compat.GraphicalEffects
import "../fragments"
import "../network/graphql/service"
import "../network/graphql"
import "../network/graphql/model"
import "../"

Item{
    function sendBusActivity(busId, location , congestionLevel){
        console.log("PINNING ", busId, JSON.stringify(location), congestionLevel)
        map.addPin(location.latitude, location.longitude, busId ,congestionLevel)
    }
    Flickable{
        anchors.fill: parent
        clip:true
        contentHeight: mDashboard.height
        ColumnLayout{
            id: mDashboard
            width: parent.width
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 250
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                radius: 8
                id: littleMapContainer
                MapFragment{
                    id: map
                    anchors.fill: parent
                    layer.enabled: true
                    layer.effect: OpacityMask{
                         maskSource: littleMapContainer
                    }
                }

            }

            Text{
                text:"Live Bus Location"
                font.pixelSize: 16
                color:"white"
                leftPadding: 10
                topPadding: 16
                font.weight: 700
            }
            Item{
                Layout.preferredHeight: 6
            }
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                visible: routeBus.model.length === 0

                Rectangle {
                    width: parent.width - 24
                    height: parent.height
                    anchors.centerIn: parent
                    radius: 12
                    color: "#333"
                    border.color: "#555"
                    border.width: 1

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "#00000066"

                        x: 0
                        y: 4
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 10
                        anchors.margins: 16
                        width: parent.width * 0.9

                        Row {
                            spacing: 8
                            anchors.horizontalCenter: parent.horizontalCenter

                            AppIcon{
                                iconType: IconType.qrcode
                                size: 24
                                color: "white"
                            }

                            Text {
                                text: "Scan to register your ride"
                                font.pixelSize: 16
                                font.bold: true
                                color: "white"
                            }
                        }

                        Text {
                            text: "To view live bus locations, please scan the bus QR code inside the bus."
                            color: "#bbb"
                            font.pixelSize: 13
                            wrapMode: Text.WordWrap
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Button {
                            text: "📷 Scan Now"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 14
                            background: Rectangle {
                            radius: 8
                            color: "#00BCD4"
                            }
                            onClicked: qrScanner.open()
                        }
                    }
                }
            }

            Repeater{
                id: routeBus
                model: []
                delegate:RowLayout{
                    Rectangle{
                        Layout.preferredWidth: 35
                        Layout.preferredHeight: 35
                        Layout.leftMargin: 10
                        color:"#55556F"
                        radius: 8
                        AppIcon{
                            iconType:  IconType.bus
                            anchors.centerIn: parent
                        }
                    }

                    Item{
                        Layout.preferredWidth: 8
                    }
                    ColumnLayout{
                        spacing: 0
                        Text{
                            font.pixelSize: 16
                            text:"Route %1".arg(modelData.route)
                            color:"white"
                            font.weight: 600
                        }

                        Text{
                            font.pixelSize: 14
                            text:"Bus %1".arg(modelData.bus)
                            color:"#888888"
                        }
                    }


                }
            }

            Item{
                Layout.preferredHeight: 24
            }
            Text{
                text:"Passenger Load"
                leftPadding: 10
                color:"white"
                font.pixelSize: 16
                font.weight: 700
            }
            Item{
                Layout.preferredHeight: 16
            }

            Item{
                visible : routeBus.model.length ===0
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                Rectangle {
                    width: parent.width - 24
                    height: parent.height
                    anchors.centerIn: parent
                    radius: 12
                    color: "#333"
                    border.color: "#555"
                    border.width: 1

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "#00000066"

                        x: 0
                        y: 4
                    }

                    Row {
                        spacing: 8
                        anchors.centerIn: parent

                        AppIcon{
                            iconType: IconType.qrcode
                            size: 24
                            color: "white"
                        }

                        Text {

                            text: "Scan to see bus passenger load"
                            font.pixelSize: 16
                            font.bold: true
                            color: "white"
                        }
                    }

                }
            }


            Text{
                text:"%1% Full".arg(loadBar.value*100)
                leftPadding: 10
                color:"white"
                font.weight: 500
                visible: routeBus.model.length > 0
            }
            Item{
                visible: routeBus.model.length > 0
                Layout.fillWidth: true
                Layout.preferredHeight: 10
                Layout.leftMargin: 10
                Layout.rightMargin: 10

                ProgressBar{
                    id: loadBar
                    width: parent.width
                    height: parent.height
                    property int maxPassenger
                    property int currentPassenger
                    background: Rectangle{
                        color:"#686868"
                        radius: 8
                    }
                    contentItem: Rectangle{
                        id : indicator
                        width:  loadBar.width * loadBar.value


                        radius: 8
                    }
                    value : currentPassenger/maxPassenger


                    onValueChanged: {
                        if(width === 0 ){
                            Qt.callLater(()=>{
                                             valueChanged()
                                         })
                            return
                        }
                        animIndicator.start()

                    }
                    property int lastValue: 0
                    PropertyAnimation{
                        id: animIndicator
                        target: indicator
                        from: loadBar.lastValue
                        to: loadBar.width* loadBar.value
                        property: "width"
                        easing: Easing.OutBounce
                        duration: 800
                        onFinished: {
                            loadBar.lastValue = animIndicator.to
                        }
                    }
                }

            }


            Text{
                text:"%1 passengers".arg(passenger)
                color:"#999999"
                leftPadding: 10
                topPadding: 8
                font.pixelSize: 14
                visible: routeBus.model.length > 0
                id: numPassenger
                property int passenger

            }

            Text{
                text:"Congestion HeatMap"
                font.pixelSize: 20
                color:"white"
                font.weight: 700
                topPadding: 24
                leftPadding:10
                bottomPadding: 24
            }

            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 250
                Layout.leftMargin:10
                Layout.rightMargin: 10
                radius: 8
            }

            Text{
                text:"Peak Hour Trends"
                font.pixelSize: 20
                color:"white"
                font.weight: 700
                Layout.topMargin: 24
                Layout.leftMargin: 10
                Layout.bottomMargin: 30
            }
            Text{
                text:"Peak Hours"
                color:"white"
                font.pixelSize: 16
                font.weight: 500
                Layout.leftMargin:10
            }
            Text{
                text:"100%"
                font.pixelSize: 40
                color:"white"
                Layout.leftMargin: 10
                font.weight: 700
            }

            Text{
                text:"Last 7 Days + <m style='color:green'>10%</m>"
                textFormat: Text.MarkdownText
                color:"#686868"
                Layout.leftMargin: 10


            }
            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 250
            }

            Text{
                text:"Station Load Ranking"
                color:"white"
                font.pixelSize: 18
                Layout.leftMargin: 10
                Layout.topMargin: 24
                font.weight: 700
            }
            Repeater{
                model:[{"station":"A", "passenger":10},
                {"station":"B", "passenger":8},
                {"station":"C","passenger":5}]
                delegate:RowLayout{

                    Rectangle{
                        Layout.preferredWidth: 35
                        Layout.preferredHeight: 35
                        Layout.leftMargin: 10
                        Layout.topMargin: 5
                        color:"#55556F"

                        radius:8
                        AppIcon{
                            iconType: IconType.mapmarker
                            color:"#d8d8d8"
                            anchors.centerIn: parent
                            size: 25
                        }
                    }
                    ColumnLayout{
                        Layout.topMargin: 5
                        Layout.leftMargin: 8
                        spacing:0
                        Layout.alignment: Qt.AlignVCenter
                        Text{
                            text:"Station %1".arg(modelData.station)
                            font.pixelSize: 16
                            color:"white"
                            font.weight: 500
                        }
                        Text{
                            text:"%1 Passengers".arg(modelData.passenger)
                            font.pixelSize: 14
                            color:"#686868"
                            font.weight: 400
                        }
                    }
                }
            }
        }
    }



    Component.onCompleted: {
    }
    Timer{
        repeat:true
        running:true
        interval:1000
        onTriggered: {
            //  pos.positionChanged()
        }
    }

    PositionSource{
        id: pos
        active: true
        updateInterval: 1000
        property var counter:0
        onPositionChanged: {
            map.addPin(pos.position.coordinate.latitude,
                       pos.position.coordinate.longitude,
                       "me")
        }

    }

    Drawer{
        parent: Overlay.overlay
        modal:true
        edge: Qt.BottomEdge
        id: qrScanner
        property var captured: null
        width: parent.width
        height: parent.height
        property bool closed:true
        QrScanner{
            anchors.fill: parent
            id: scanner
            onQrCaptured: (c)=> {
              if(!qrScanner.opened) return
              qrScanner.captured = c

              console.log(scanner.lastCapture, qrScanner.captured)
              qrScanner.close()
              loading.open()
              try{
                  var json = JSON.parse(qrScanner.captured)
                  gbn.busId = json.busId
                  gbn.sendRequest((s,d)=>{
                    loading.close()
                    if(!s){
                        //show error
                    }

                    /*
                    PeakMapConfig.currentBusId = gbn.busId
                    PeakMapConfig.currentBusName = d

                    routeBus.model =[{ "bus":d, "route":"Getting info, Please wait.."  }]
                    */
                  })
              }catch(err){
                  console.log(err)
              }

            }
        }

        onOpened: {
            if(!qrScanner.closed) return

            qrScanner.closed= false
        Qt.callLater(()=>{
            qrScanner.captured = null
            scanner.resume()
                     })
        }


        onClosed: {
            qrScanner.closed= true
            console.log('closed')
            Qt.callLater(()=>{
                scanner.paused()
                         })
        }

     //   Component.onCompleted:  qrScanner.close()
    }


    GetCapacityLoad{
        id:gbn
        dataItem: Component{
            CapacityLoadType{
                id:capacity
                onCaptureData:{
                     busActivity.busId = gbn.busId
                    routeBus.model= [
                        {
                            "bus": capacity.busName.value,
                            "route":"Getting info, Please wait.."
                        }
                    ]
                    numPassenger.passenger = capacity.currentPassengers.value
                    loadBar.maxPassenger = capacity.maxPassengers.value
                    loadBar.currentPassenger =  capacity.currentPassengers.value
                    console.log("SUBS ", JSON.stringify(busActivity))
                    busActivity.subscribe()
                }
            }
        }
        onDelegateReturn: (d)=> d.captureData()

    }

    Loading{
        id: loading
    }
    BusActivityUpdateSubscription{
        id: busActivity
        dataItem: Component{
            BusActivity{
                id: ba
                onCaptureData: {
                    loadBar.currentPassenger = ba.passengerCount.value
                    numPassenger.passenger = ba.passengerCount.value
                }
            }
        }
        onDelegateReturn:  (d)=> d.captureData()
    }
}
