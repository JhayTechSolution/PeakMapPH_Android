import QtQuick 2.15
import QtPositioning
import QtLocation 5.15
import Felgo
AppMap {
    id: map
    anchors.fill: parent
    plugin: Plugin {
           name: "maplibregl"
           // configure your styles and other parameters here
           parameters: [
             PluginParameter {
               name: "maplibregl.mapping.additional_style_urls"
               value: "https://api.maptiler.com/maps/streets/style.json?key=eoyM2IVzVRfga9GPrIAW"
             }
           ]
         }
    center: QtPositioning.coordinate(14.5995, 120.9842)
    zoomLevel:12


    /*
    // Sample heatmap data points
    ListModel {
        id: heatmapData
        ListElement { lat: 14.5995; lon: 120.9842; intensity: 0.8 }
        ListElement { lat: 14.6040; lon: 120.9820; intensity: 0.6 }
        ListElement { lat: 14.5980; lon: 120.9900; intensity: 0.9 }
        // Add more data points...
    }

    // Render circles for each data point
    Repeater {
        model: heatmapData
        MapCircle {
            center: QtPositioning.coordinate(model.lat, model.lon)
            radius: 300 // in meters
            color: Qt.rgba(1, 0, 0, model.intensity) // red with alpha based on intensity
            border.width: 0
        }
    }
    */
    property var pins : []
    function getExistingPin(routeName){
        for(var i=0; i  < pins.length; i++){
            var current= pins[i]
            if(current.routeName === routeName){
                return i
            }
        }
        return -1
    }

    function addPin(latitude, longitude, routeName, congestionLevel="light") {
        let pinNumber = map.getExistingPin(routeName)
        if (pinNumber > -1) {
            // Pin already exists — just update its position
            pins[pinNumber].coordinate = QtPositioning.coordinate(latitude, longitude)

        } else {
            // Create new pin
            var pin = pinComponen.createObject(map)
            pin.routeName = routeName
            if(routeName === "me"){
                pin.me = true
            }
            pin.congestionLevel = congestionLevel.toLowerCase()

            pin.coordinate = QtPositioning.coordinate(latitude, longitude)
            addMapItem(pin)
            pins.push(pin)
        }
    }



    Component{
        id: pinComponen
        MapQuickItem{
            anchorPoint.x: icon.width/2
            anchorPoint.y: icon.height
            property string routeName
            property bool me
            property string congestionLevel: "light"
            id: pin
            sourceItem: Image{
                id: icon
                source: (me)? "qrc:/assets/me.png" : (()=>{

                    if(pin.congestionLevel === "light"){
                        return "qrc:/assets/marker_green.png"
                    }else if(pin.congestionLevel === "moderate"){
                        return "qrc:/assets/marker_yellow.png"
                    }else if(pin.congestionLevel === "critical"){
                        return "qrc:/assets/marker_orange.png"
                    }else if(pin.congestionLevel === "full"){
                        return "qrc:/assets/marker_red.png"
                    }else{
                        return "qrc:/assets/marker_green.png"
                    }

                })()
                width:30
                height: 30
            }
            AppToolTip{
                anchors.fill: parent
                text: routeName
            }
        }
    }
}
