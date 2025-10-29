import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Shapes 6.5
import "../components"
import PeakMapPHApp
import Com.Plm.PeakMapPH 1.0
import QtCore
import Qt5Compat.GraphicalEffects
import QtLocation
import QtPositioning
Item{
    id: window
    signal serviceCreatedData()
    signal alight()
    signal onboarded()
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: parent.width * 0.8


        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 4
            Label {
                text: "Start Bus Activity"

                font.bold: true
                font.pixelSize: 28
                color: "#DDD"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "Connect to a Bluetooth device to begin your shift"
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                color: "#AAA"
                font.pixelSize: 15
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }


        Rectangle {
            width: 160
            height: 160
            radius: 20
            color: "#f0f0f0"
            Layout.alignment: Qt.AlignHCenter
            AppIcon{
                iconType: IconType.bluetooth
                size: 48
                anchors.centerIn: parent
            }

        }


        Label {
            text: "Please connect to a Bluetooth device from your dispatch or bus to start the activity."
            wrapMode: Text.WordWrap
            Layout.fillWidth:true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 15
            color: "#a8a8a8"
        }


        ColumnLayout {
            spacing: 10
            Layout.fillWidth: true
            Button {
                text: "Connect Now"
                font.pixelSize: 16
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#2d77ff"
                    radius: 12
                }
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 16
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    console.log(bluetoothPerms.status, Qt.Granted )
                    if(bluetoothPerms.status === Qt.Granted){

                        bluetoothHelper.ensureBluetoothEnabled()
                        return
                    }
                    bluetoothPerms.statusChanged()
                }
            }

        }


        Label {
            Layout.fillWidth: true
            text: "You're logged in as: %1".arg(PeakMapConfig.fullName)
            font.pixelSize: 13
            color: "#DDD"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            topPadding: 20
        }
        Label {
            Layout.fillWidth: true
            text: " Driver ID: %2".arg(PeakMapConfig.id)
            font.pixelSize: 13
            color: "#DDD"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAnywhere
            Layout.leftMargin: 24
            Layout.rightMargin: 24

        }
    }
    BluetoothHelper{
        id: bluetoothHelper
        onBluetoothEnabled: {
            searchDevices.open()
        }
        onBluetoothDisabled: {
            console.log('bluetooth disabled')
        }
    }
    BluetoothPermission{
        id: bluetoothPerms
        onStatusChanged: {
            if(status !== Qt.Granted){
                request()
            }else{

                bluetoothHelper.ensureBluetoothEnabled()
            }
        }
    }

    function getTodayKey() {
      const now = new Date();
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, "0"); // Months are 0-indexed
      const day = String(now.getDate()).padStart(2, "0");
      return `${year}-${month}-${day}`;
    }
    Drawer{
        id: searchDevices
        modal: true
        parent:  Overlay.overlay
        width: parent.width
        height: parent.height
        edge:Qt.BottomEdge
        interactive: false
        background: Rectangle{
            color:"transparent"
        }

        Rectangle{
            anchors.fill: parent
            color:"#80FFFFFF"
            Frame{
                background:Rectangle{
                    color:"white"
                    radius: 8
                    Rectangle{
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 48

                    }
                }

                anchors.bottom: parent.bottom
                width: parent.width

                height: listOfDevice.height + 24
                ColumnLayout{
                    id: listOfDevice
                    width: parent.width
                    Item{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        RowLayout{
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width

                            Text{
                                text:"Choose Device"
                                font.pixelSize: 16
                                font.weight: 700
                                Layout.fillWidth: true
                            }
                             AppIcon{
                                 iconType: IconType.times
                                 size: 24
                                MouseArea{
                                    anchors.fill: parent
                                    onPressed: {
                                        opacity= 0.5
                                    }
                                    onReleased: {
                                        opacity =1
                                         searchDevices.close()
                                    }
                                }
                             }


                        }
                    }
                    Rectangle{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color:"#e8e8e8"
                    }

                    Repeater{
                        id: mRepeater
                        model: window.devices
                        delegate: Rectangle{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            clip: true

                            border.color: "#d8d8d8"
                            ColumnLayout{
                                anchors.fill: parent
                                Text{
                                    padding: 16
                                    text: modelData.name
                                    font.pixelSize: 16
                                    font.weight: 600

                                }
                                Text{
                                    padding: 16
                                    text: modelData.address
                                    font.pixelSize: 14
                                    font.weight: 500
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    parent.color = "#e8e8e8"

                                }
                                onReleased:{
                                    parent.color="white"
                                    peakMapScanner.stopScan()
                                    Qt.callLater(()=>{
                                        modelData.connectDevice()

                                        var serviceCreated=(service)=>{
                                            console.log('SERVICE CREATED', service)
                                            service.serviceReady.connect(()=>{
                                                console.log('Service is ready');
                                                service.sendData(PeakMapConfig.aesHelper.encrypt("HELLO_PEAKMAP"))
                                            })
                                            service.receivedData.connect((data)=>{
                                                console.log("RECEIVED ", data);
                                                let aesData = PeakMapConfig.aesHelper.decrypt(data)
                                                if(PeakMapConfig.busId !== "" && PeakMapConfig.busId !== null){
                                                    if(aesData === "alight"){
                                                        alight()
                                                        return
                                                    }
                                                    if(aesData === "onboard"){
                                                        onboarded()
                                                        return

                                                    }else if(aesData=== "START_OKAY"){
                                                       var dts = JSON.stringify({
                                                            mp : PeakMapConfig.maxPassenger,
                                                            cp: PeakMapConfig.currentPassenger
                                                        }).replace("g/\\n/+$"," ").trim()
                                                        PeakMapConfig.currentService.sendData(PeakMapConfig.aesHelper.encrypt(dts))
                                                        PeakMapConfig.deviceBooted = false
                                                    }else if(aesData === "BOOTED"){
                                                        PeakMapConfig.deviceBooted= true
                                                    }

                                                    return
                                                }

                                                if(aesData !== ""){
                                                    var json =JSON.parse(aesData)
                                                    var keys =Object.keys(json);

                                                    if(PeakMapConfig.busId === "" || PeakMapConfig.busId === null){
                                                        if(keys.indexOf("bus_id")){
                                                            var key = getTodayKey()

                                                            PeakMapConfig.currentService = service
                                                            PeakMapConfig.busId = json['bus_id']
                                                            gbn.busId = PeakMapConfig.busId
                                                            gbn.sendRequest((s,e)=>{
                                                                if(!s){
                                                                    myPosition.sendBusActivity()
                                                                }else{
                                                                    saveSession(e)
                                                                }

                                                            })
                                                            cba.busId = PeakMapConfig.busId


                                                        }
                                                    }
                                                }

                                            })
                                        }


                                        modelData.serviceCreated.disconnect(serviceCreated)
                                        modelData.serviceCreated.connect(serviceCreated)
                                    })
                                }
                            }
                        }
                    }

                    Item{
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 48
                        Layout.bottomMargin:48
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        id: loadingDevice
                        visible:  window.devices.length === 0
                        BusyIndicator{
                            anchors.centerIn: parent
                            running:loadingDevice.visible
                            layer.enabled: true
                            layer.effect: ColorOverlay{
                                color:"#888888"
                            }
                            width: 48
                            height: 48
                        }

                        Text{
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            text:"Loading devices, please wait"

                        }
                    }
                }
            }

        }
        onAboutToShow: {
            peakMapScanner.discoverBluez()
            Qt.callLater(()=>{
                mTimer.start()
            })
        }
        onAboutToHide: {
            peakMapScanner.stopScan()
            Qt.callLater(()=>{
                mTimer.stop()
            })
        }


    }

    PeakMapBluez{
        id:  peakMapScanner
        onScannedComplete: {
             console.log('scan complete', devices)
        }
        onScanError: {
            console.log('error scan')
        }

        onDeviceUpdated: {
           window.devices =[]
           window.devices = peakMapScanner.devices
        }
    }
    property list<var> devices
    onDevicesChanged: {
        console.log('Devices changed' , devices)
    }


    GetCapacityLoad{
        id: gbn
    }
    CreateBusActivity{
        id: cba
        busId: PeakMapConfig.busId
    }
    PositionSource{
        id: myPosition
        updateInterval: 500
        active: true

        onPositionChanged: {
            var coord  =position .coordinate

        }

        function sendBusActivity(){
            cba.lat = position.coordinate.latitude
            cba.lon  = position.coordinate.longitude
            cba.passengerCount = 0

            active = false
            cba.sendRequest((s,e1)=>{
                if(s){
                    gbn.sendRequest((s1,e)=>{
                                        if(!s1) return
                                        saveSession(e)



                                    })
                }
            })
        }
    }
    function saveSession(e){
        PeakMapConfig.currentPassenger = e['currentPassengers']
        PeakMapConfig.maxPassenger= e['maxPassengers']
        PeakMapConfig.busName= e['busName']

        searchDevices.close()
        serviceCreatedData()

    }

    Timer{
        id: mTimer
        repeat: true
        interval: 3000 //3 seconds will repeat scan
        running : false
        onTriggered: {
            console.log("RESTART SCANNER")
            if(peakMapScanner.devices.length > 0 ){
                peakMapScanner.stopScan()
                mTimer.stop()
                return

            }

            peakMapScanner.stopScan()
            peakMapScanner.discoverBluez()
        }
    }



}
