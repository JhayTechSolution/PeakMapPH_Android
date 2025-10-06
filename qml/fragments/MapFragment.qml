import QtQuick
import QtPositioning
import QtLocation
import QtQuick.Controls

import Qt5Compat.GraphicalEffects
Map{

    Item{
        id: justMask
        anchors.fill: parent
    }

    PinchHandler {

        id: pinch
        target: justMask // target your map item directly

         onScaleChanged: (delta) => {
             map.zoomLevel += Math.log2(delta)
         }



    }

    DragHandler {
        id: drag
        target: null
        onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
    }
    enum MapType{
        Normal,
        HeatMap
    }
    property int mapType : MapFragment.MapType.Normal
    onMapTypeChanged: {
        if(mapType === MapFragment.MapType.HeatMap){
            pluginMap.value = "qrc:/assets/mapstyle.json"
        }else{
            pluginMap.value = "https://api.maptiler.com/maps/streets/style.json?key=eoyM2IVzVRfga9GPrIAW"
        }
        pluginMap.initialized()
    }

    function lonToTileX(lon) {
        return Math.floor(((lon + 180) / 360) * Math.pow(2, zoomLevel));
    }

    function latToTileY(lat) {
        const rad = lat * Math.PI / 180;
        return Math.floor(
            (1 - Math.log(Math.tan(rad) + 1 / Math.cos(rad)) / Math.PI) / 2 * Math.pow(2, zoomLevel)
        );
    }

    id: map
    anchors.fill: parent
    plugin: Plugin {
           name: "maplibre"
           // configure your styles and other parameters here
           parameters: [
             PluginParameter {
                id: pluginMap

               name: "maplibre.map.styles"
               value:{
                   console.log("MAPTYPE ",map.mapType)
                   if(map.mapType === MapFragment.MapType.HeatMap) {
                       console.log("MAPTYPE HEATMAP")
                       return "qrc:/assets/mapstyle.json"
                   }

                  return "https://api.maptiler.com/maps/streets/style.json?key=eoyM2IVzVRfga9GPrIAW"
               }

             }
         ]
    }
    center: QtPositioning.coordinate(14.5995, 120.9842)


    property var rasterData: []
    Repeater{
        model: rasterData
        MapQuickItem{
            sourceItem: Image{
                source: tomTomUrl.arg(modelData.zoomLevel).arg(modelData.tileX).arg(modelData.tileY).arg(apiKey)
            }
            Component.onCompleted: {
                addMapItem(this)
                console.log('adding this item')
            }
        }
    }

    Component{
        id: raster
        MapQuickItem{
            property string imageUrl
            sourceItem: Image{
                id: rasterImage
                source: imageUrl

            }
        }
    }

    zoomLevel:12

    property var heatMapPoints: []// {congestion, target}
    onHeatMapPointsChanged: {
        heatMapView.model = []
        heatMapView.model = heatMapPoints
    }


    MapItemView{
        id: heatMapView
        delegate:  HeatMapCloud{
            mapZoomLevel:  map.zoomLevel
            coordinate: QtPositioning.coordinate(modelData.target.latitude, modelData.target.longitude)
            congestionLevel: (modelData.congestion.toLowerCase() === "medium")? HeatMapCloud.CongestionLevel.MEDIUM:
                             (modelData.congestion.toLowerCase() === "high")?
                                                                            HeatMapCloud.CongestionLevel.HIGH:
                                                                            HeatMapCloud.CongestionLevel.LOW
            id: heatmap
            Connections{
                target:  map
                function onZoomLevelChanged(zoomLvel){
                    console.log('zoom level changed')
                    heatmap.zoomLevelChange(map)
                }
                function onCenterChanged(coordinate){
                    heatmap.centerChange(map)
                }

             }
        }
    }

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
            pins[pinNumber].congestionLevel= congestionLevel.toLowerCase()
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
            ToolTip{
                text: routeName
            }
        }
    }


}
