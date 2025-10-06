import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15

MapQuickItem {
    id: cloud

    enum CongestionLevel {
        HIGH,
        MEDIUM,
        LOW
    }

    property var center
    property real radiusMeters:1000
    property int congestionLevel: HeatMapCloud.CongestionLevel.MEDIUM

     anchorPoint.x: width / 2
     anchorPoint.y: height / 2
    property real mapZoomLevel
     onMapZoomLevelChanged: {
         if(mapZoomLevel > 0){
             console.log(coordinate.latitude, mapZoomLevel)
            pixelRadius = metersToPixelsAtLatitude(radiusMeters, coordinate.latitude,mapZoomLevel)

         }
     }

    property real pixelRadius
    onPixelRadiusChanged: {
        if(pixelRadius > 0){
            cloud.width = Math.ceil(pixelRadius * 2)
            cloud.height =width
            canvas.width=cloud.width
            canvas.height = cloud.height
        }
    }



    sourceItem: Canvas {
        id: canvas
        property var ctx
        property int finalWidth: 0
        property int finalHeight: 0
        onAvailableChanged: {
           if(available){
               console.log("ITS NOW AVAILABLE" , width)
               ctx = getContext("2d")
               if(width > 0){
                   requestPaint()
               }else{
                   availableChanged()
               }
           }

        }

        onWidthChanged: {
            if(width > 0 ){
                finalWidth=width
                return
            }
            if(width === 0){
                width = finalWidth
            }




        }

        onPaint:{
            console.log("REQUESTED painting", width, height)
            if(!ctx) return
            ctx.clearRect(0, 0, width, height)

            var r = cloud.pixelRadius
            if (r <= 0) return

            var cx = width / 2
            var cy = height / 2
            console.log("Painting ",coordinate.latitude, coordinate.longitude)
            var grad = ctx.createRadialGradient(cx, cy, 0, cx, cy, r)

            if (cloud.congestionLevel === HeatMapCloud.CongestionLevel.HIGH) {
                console.log("HIGH CONGESTION")

                grad.addColorStop(0.0, Qt.rgba(255,0,0,0.6))
                grad.addColorStop(0.4, Qt.rgba(255,255,0,0.4))
                grad.addColorStop(0.8, Qt.rgba(0,255,0,0.25))
                grad.addColorStop(1.0, Qt.rgba(0,0,0,0.0))
            } else if(cloud.congestionLevel === HeatMapCloud.CongestionLevel.MEDIUM){

                grad.addColorStop(0.4, Qt.rgba(255,255,0,0.5))
                grad.addColorStop(0.6, Qt.rgba(0,255,0,0.3))
                grad.addColorStop(1.0, Qt.rgba(0,0,0,0.0))
            }else{
                grad.addColorStop(0.6, Qt.rgba(0,255,0,0.3))
                grad.addColorStop(1.0, Qt.rgba(0,0,0,0.0))

            }

            ctx.fillStyle = grad
            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 2)
            ctx.fill()
        }
    }
    function zoomLevelChange(map){
        cloud.pixelRadius= metersToPixelsAtLatitude(radiusMeters, coordinate.latitude,map.zoomLevel)
        canvas.requestPaint()
    }
    function centerChange(map){
        cloud.pixelRadius= metersToPixelsAtLatitude(radiusMeters, coordinate.latitude,map.zoomLevel)
        canvas.requestPaint()
    }

    function metersToPixelsAtLatitude(meters, lat, zoom) {
        if (zoom <= 0) return 0
        var metersPerPixel = 156543.03392804062 * Math.cos(lat * Math.PI / 180) / Math.pow(2, zoom)
        return meters / metersPerPixel
    }
}
