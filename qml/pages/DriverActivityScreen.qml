import QtQuick 6.5
import "../components"
import QtQuick.Layouts
import QtQuick.Controls
import PeakMapPHApp
import QtLocation
import QtPositioning
import "../network/graphql/model"
Item{
    property bool booted:PeakMapConfig.deviceBooted
    property real lastLatitude:0
    property real lastLongitude:0
    property string currentLocation :"Unknown Location"
    function congestionLevel(){
        const ratio = PeakMapConfig.currentPassenger / PeakMapConfig.maxPassenger;

           if (ratio < 0.5) {
               return "LIGHT";
           } else if (ratio < 0.8) {
               return "MODERATE";
           } else if (ratio < 1) {
               return "CRITICAL";
           } else {
               return "FULL";
           }
    }
    property var cl : congestionLevel()

    function alight(){
        alightRequest++
        myPosition.positionChanged()
    }
    function onboarded(){
        onboardRequest++;
        myPosition.positionChanged()
    }
    function reposition(){
        myPosition.positionChanged()
    }

    ColumnLayout{
        anchors.fill: parent
        Frame{
            Layout.preferredWidth:  parent.width - 24
            Layout.alignment: Qt.AlignHCenter
            background:Rectangle{
                radius: 8
                color:"#00000000"
            }
            clip:true
            ColumnLayout{
                id: mContent
                width : parent.width
                Text{
                    text:"BUS : %1".arg(PeakMapConfig.busName)
                    font.pixelSize: 24
                    color:"white"
                    font.weight: 700

                }
                Text{
                    text:"Driver: %1".arg(PeakMapConfig.fullName)
                    font.pixelSize: 16
                    font.weight: 500
                    color:"white"

                }

                Text{
                    color:"white"
                    font.pixelSize:16
                    font.weight: 500
                    text:"Current Location: %1".arg(currentLocation)
                }
                Text{
                    color:"white"
                    font.pixelSize:16
                    font.weight: 500
                    text:"Passengers: %1/%2".arg(PeakMapConfig.currentPassenger).arg(PeakMapConfig.maxPassenger)
                }

                Text{
                    color:"white"
                    font.pixelSize:16
                    font.weight: 500
                    text:"Load Status : %1".arg(cl)
                    textFormat: Text.MarkdownText
                }

                Text{
                    color:"white"
                    font.pixelSize: 16
                    font.weight: 500
                    textFormat: Text.MarkdownText
                    text:"Device Status: %1".arg((function(){
                        if(!booted){
                            return "<m style='color:yellow'>Booting</m>";
                        }else{
                            return "<m style='color:green'>Booted</m>"
                        }
                    })())
                }
            }
            Layout.preferredHeight: mContent.height+ 24
        }
        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true
            MapFragment{
                id: mapFragment
                anchors.fill: parent
            }

        }
        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            Layout.rightMargin: 24
            Button{
                text:"Reset passenger counter"
                font.pixelSize: 16
                font.weight: 700
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    confirmReset.open()
                }


            }
        }

    }
    PositionSource{
        id: myPosition
        onPositionChanged: {
            var coord  =position .coordinate
            gln.lat = coord.latitude
            gln.lon = coord.longitude
            if(coord.latitude !== lastLatitude &&
                    coord.longitude !== lastLongitude && (currentLocation === "" || currentLocation == "Unknown Location")){
                    gln.sendRequest((s,e)=>{
                        if(s){
                            if(e !== "Unknown Location"){
                                lastLatitude = coord.latitude
                                lastLongitude = coord.longitude
                            }

                            currentLocation = e
                        }
                    })
            }
            mapFragment.addPin(coord.latitude, coord.longitude, 'bus', 'LOW')

            if(busy) return
            if(PeakMapConfig.busId == "" || PeakMapConfig.busId == null || typeof PeakMapConfig.busId == "undefined") return
            ubc.lat = coord.latitude
            ubc.lon  = coord.longitude
            if(totalToRequest > 0){
                try{
                    //onboard
                    ubc.action="ONBOARD"
                    busy=true
                    ubc.sendRequest((s,e)=>{
                        if(s){
                            onboardRequest--;
                            PeakMapConfig.currentPassenger++;

                        }
                        busy=false;
                    })
                }catch(err){
                    console.log(err)
                    busy=false
                }

            }else if(totalToRequest < 0){
                try{
                    ubc.action="ALIGHT"
                    busy=true
                    ubc.sendRequest((s,e)=>{
                        if(s){
                            alightRequest--;
                            PeakMapConfig.currentPassenger--;

                        }

                        busy=false;
                    })
                }catch(err){
                    console.log(err)
                    busy = false
                }
            }else{
                //zero , createbusactivity for monitoring
                cba.lat = coord.latitude
                cba.lon = coord.longitude
                busy=true
                cba.passengerCount = PeakMapConfig.currentPassenger
                cba.sendRequest((s,e)=>{

                    busy=false;

                })
            }
        }
        active:true
        updateInterval: 500
    }

    //onboardrequest and alightrequest will came from bluetooth device

    property int onboardRequest: 0
    property int alightRequest: 0
    property int totalToRequest: onboardRequest - alightRequest //if negative means alighted x abs(totalToRequest) , else onboarded x abs(totalToRequest)
    property bool busy:false

    UpdateBusCounter{
        id: ubc
        busId: PeakMapConfig.busId
        onDelegateReturn: {
            cl = congestionLevel()
        }

    }
    CreateBusActivity{
        id: cba
        busId: PeakMapConfig.busId
    }
    ClearBusActivity{
        id: clrBus

    }
    Loading{
        id: loader
    }

    GetLocationName{
        id: gln

    }
    ConfirmationBox{
        id: confirmReset
        width: parent.width
        height: parent.height
        title: "Confirm action"
        message:"Do you want to reset the data?"
        onOkCallback: {
            close()
            loader.open()
            clrBus.busId = PeakMapConfig.currentBusId
             clrBus.sendRequest((s,e)=>{

                loader.close()
                if(!s){
                    return
                }
                PeakMapConfig.currentPassenger = 0
                var dts =  PeakMapConfig.aesHelper.encrypt(JSON.stringify({
                    action: 'reset'
                }))
                if(PeakMapConfig.currentService){
                    PeakMapConfig.currentService.sendData(dts)
                }

                //createBusActivity
                myPosition.positionChanged()
            })
        }
    }
}

