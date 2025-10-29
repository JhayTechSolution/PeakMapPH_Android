import QtQuick
import "../components"
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
import QtCharts
import "../db"

import Com.Plm.PeakMapPH 1.0
import PeakMapPHApp
Item{
    function startLoad(){

        console.log("GET BUS")
        ga.analyticsType="PeakHours"
        ga.timeRange = "Daily"
        ga.sendRequest((s,e)=>{})
        getCurrentBusIfAny()
        ghm.sendRequest((s,e)=>{})
        gtba.sendRequest((s,e)=>{})
        /*
        gbn.busId="18c849fe9bd87741ab89b191e35c42a7de5e4712120d6b68a5f6480609082535"
        gbn.sendRequest((s,e)=>{})
        */
        stationLoadRank.sendRequest((s,e)=>{
            sendLoadRank(e)
        })

    }

    signal updateAlerts()
    property bool hasBus: false
    property string busId: ""
    property real currentBusLatitude
    property real currentBusLongitude
    function sendBusActivity(busId, location , congestionLevel){
        map.addPin(location.latitude, location.longitude, busId ,congestionLevel)
        ga.sendRequest({})
    }
    function sendLoadRank(loadRankModel){
        loadRank=[]
        loadRank= loadRankModel
        ga.sendRequest({})
    }

    property var loadRank: []

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
                clip:true
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
                Layout.preferredHeight: 160
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
                                iconType: IconType.qrCode
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
                            size: 24
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
                            iconType: IconType.qrCode
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
                    property string congestionLevel:"LIGHT"
                    background: Rectangle{
                        color:"#686868"
                        radius: 8
                    }
                    contentItem: Rectangle{
                        id : indicator
                        width:   loadBar.width * loadBar.value
                        color: {
                            let cg = loadBar.congestionLevel.toUpperCase()
                            console.log(cg)
                            if(cg === "LIGHT"){
                                return "#A3E635"
                            }else if(cg === "MODERATE"){
                                return "#F59E0B"
                            }else{
                                return "#EF4444"
                            }
                        }

                        radius: 8
                    }
                    value : currentPassenger/maxPassenger


                    onValueChanged: {
                        if(width === 0 ){
                            Qt.callLater(()=>{
                                             try{
                                                 valueChanged()
                                             }catch(err){}
                                         })
                            return
                        }
                        Qt.callLater(()=>{
                            if(loadBar.congestionLevel.toUpperCase() === "FULL"){
                                indicator.width  = loadBar.width
                                return
                            }
                            if(currentPassenger === 0){
                                indicator.width = 0
                                return
                            }

                            animIndicator.start()
                                     })

                    }
                    property int lastValue: 0
                    PropertyAnimation{
                        id: animIndicator
                        target: indicator
                        from: loadBar.lastValue
                        to: (loadBar.congestionLevel.toUpperCase() === "FULL") ? loadBar.width:  loadBar.width* loadBar.value
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
                clip: true
                id:  mCongestion
                MapFragment{
                    id: heatmapType
                    mapType: MapFragment.MapType.HeatMap
                }
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
                text:"%1%".arg(chartScreen.change)
                font.pixelSize: 40
                color:"white"
                Layout.leftMargin: 10
                font.weight: 700
            }

            Text{
                id: last7days
                text: "Last 7 days <m style='color:%1'>%2%</m>".arg(chartScreen.indicatorColor).arg(chartScreen.change)

                textFormat: Text.MarkdownText
                color:"#686868"
                Layout.leftMargin: 10


            }
            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 250
                Layout.leftMargin: 10
                Layout.rightMargin: 10

                ChartScreen{
                    id: chartScreen

                    property int change

                    property string indicatorColor: (change < 0) ? "#FF073A": "#39FF14"

                    hasLabelY: false
                    gridLinesColor: "#00000000"
                    dataBackgroundColor: "#585858"
                    dataBorderColor: "#FFFFFF"
                    chartStyle: ChartScreen.ChartType.Line
                    dataSets: [
                    [0,0,0,0,0,0,0]
                    ]
                }
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
                model: loadRank
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
                            text:"Station %1".arg(modelData.stationName)
                            font.pixelSize: 16
                            color:"white"
                            font.weight: 500
                        }
                        Text{
                            text:"%1 Passengers".arg(modelData.passengerCount)
                            font.pixelSize: 14
                            color:"#686868"
                            font.weight: 400
                        }
                    }
                }
            }
        }
    }

    function checkExist(busId, callback ){
        sqliteOps.instance(PeakMapConfig.db.useTable(prl.tableName))
        let filters = {}
        filters[prl.createdKey.columnName] = PeakMapConfig.formatDateNow()
        sqliteOps.filter(filters)
        sqliteOps.orderBy(prl.createdAt.columnName)
        sqliteOps.runQuery((data)=>{
             callback(data, sqliteOps)
        }, true)

    }

    function processBusData(data){

        var busId = data[prl.busId.columnName]
        var maxPassengers = data[prl.maxCapacity.columnName]
        var currentPassengers = data[prl.currentLoad.columnName]
        var busName  = data[prl.busName.columnName]
        var routeNae = data[prl.routeName.columnName]
        var level = data[prl.congestionLevel.columnName]
        var busLatitude = data[prl.busLatitude.columnName]
        var busLongitude = data[prl.busLongitude.columnName]
        checkExist(busId, (existData, sqliteOps)=>{
            var busData= {}
            let shouldUpdate = false
            if(existData.length > 0 ){
                busData= existData[0]
                shouldUpdate=true
            }else{
                busData[prl.busId.columnName] = busId
                busData[prl.active.columnName] = true
                busData[prl.busName.columnName] = busName
                busData[prl.createdAt.columnName] = Date.now()
                busData[prl.createdKey.columnName] = PeakMapConfig.formatDateNow()

            }
            busData[prl.maxCapacity.columnName] = maxPassengers
            busData[prl.currentLoad.columnName] = currentPassengers
            busData[prl.busLatitude.columnName] = busLatitude
            busData[prl.busLongitude.columnName] = busLongitude
            busData[prl.congestionLevel.columnName] = level
            busData[prl.routeName.columnName] = routeNae
            sqliteOps.clear()

            if(shouldUpdate){
                sqliteOps.update(busData)
            }else{
                sqliteOps.insert(busData)
            }
            registerBusToApp(busData)
        })

    }




    function registerBusToApp(data){


        busActivity.busId = data[prl.busId.columnName]
        routeBus.model =[]
        routeBus.model= [
            {
                "bus": data[prl.busName.columnName],
                "route":data[prl.routeName.columnName]
            }
        ]
        numPassenger.passenger =data[prl.currentLoad.columnName]
        loadBar.maxPassenger = data[prl.maxCapacity.columnName]
        loadBar.currentPassenger =  data[prl.currentLoad.columnName]
        loadBar.congestionLevel = data[prl.congestionLevel.columnName]
        var latitude = data[prl.busLatitude.columnName]
        var longitude = data[prl.busLongitude.columnName]
        map.addPin(latitude, longitude, busActivity.busId, loadBar.congestionLevel)
        hasBus=true
        console.log("BUS ID ", JSON.stringify(data))
        busId  = busActivity.busId
        currentBusLatitude = latitude
        currentBusLongitude = longitude
        busActivity.subscribe()

    }
    function getCurrentBusIfAny(){
        sqliteOps.clear()
        sqliteOps.instance(PeakMapConfig.db.useTable(prl.tableName))
        var filters = {}
        filters[prl.active.columnName] = true
        filters[prl.createdKey.columnName] = PeakMapConfig.formatDateNow()
        sqliteOps.filter(filters)
        sqliteOps.orderBy(prl.createdAt.columnName)
        sqliteOps.limit(1)
        sqliteOps.offset(0)
        sqliteOps.runQuery((data)=>{
           if(data.length > 0 ){
                console.log("RUN QUERY");
                var d= data[0]
                registerBusToApp(d)
            }
        },true)
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

    function getDistance(lat1, lon1 ,lat2 ,lon2){
        const R =6371000;
        const toRad =(deg) => deg* (Math.PI/180)

        const p1 = toRad(lat1)
        const p2 =toRad(lat2)
        const latdif = toRad(lat2 - lat1)
        const longdif = toRad(lon2 - lon1)

        const a = Math.sin(latdif /2 )**2 +
                  Math.cos(p1) * Math.cos(p2) *
                 Math.sin(longdif/ 2) ** 2;

        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

        return R* c;

    }

    PositionSource{
        id: pos
        active: true
        updateInterval: 500
        property real freeFlow: 60
        property var counter:0
        property int updateSentFrequency: 60 // send every 30 seconds
        property int frequencyCounter: 0
        onPositionChanged: {
            map.addPin(pos.position.coordinate.latitude,
                       pos.position.coordinate.longitude,
                       "me")


            if(!hasBus) return
            var distance = getDistance(currentBusLatitude, currentBusLongitude,
                                       pos.position.coordinate.latitude,
                                       pos.position.coordinate.longitude)

            if(distance > 50){
                //should popup that the passenger already out from the current bus
                sqliteOps.instance(PeakMapConfig.db.useTable(prl.tableName))
                var f={}
                f[prl.busId.columnName] = busId
                f[prl.active.columnName] = true
                sqliteOps.clear()
                sqliteOps.filter(f)
                sqliteOps.runQuery((data)=>{
                      if(data.length > 0 ){
                            var d=data[0]
                            d.active = false
                       }
                      sqliteOps.update(d)
                       hasBus=false
                       busId=""
                       currentBusLatitude=0
                      currentBusLongitude=0
                       routeBus.model=[]
                         numPassenger.passenger = 0
                      getCurrentBusIfAny()
                },true)

                exitPassengerPopup.open()
                return
            }

            if(frequencyCounter >= updateSentFrequency){
                frequencyCounter= 0
                return
            }

            if(position.speedValid){
                let speedKmh= position.speed * 3.6
                if(speedKmh === 0 ){
                    return
                }

                if(speedKmh > pos.freeFlow){
                    pos.freeFlow  = speedKmh
                    return
                }
                let analysisSpeed = 0
                if(speedKmh === pos.freeFlow){
                     return
                }


                analysisSpeed = ((1 - (speedKmh/freeFlow)) * 100);
                console.log("Your speed is currently "+ speedKmh + " over "+analysisSpeed, freeFlow)
                if(analysisSpeed < 10){
                    return
                }

                /*
                congestionReporter.lat = pos.position.coordinate.latitude
                congestionReporter.lon = pos.position.coordinate.longitude
                congestionReporter.speed = speedKmh //send the real speed
                congestionReporter.sendRequest((s,e)=>{

                })*/
                frequencyCounter++

            }
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
                console.log("READING ",qrScanner.captured)
                  var json = JSON.parse(qrScanner.captured)
                  gbn.busId = json.busId
                  gbn.sendRequest((s,d)=>{
                    loading.close()
                    if(!s){
                        //show e
                    }



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
                    console.log('ON CAPTURED ')
                    var d={}
                    let location = capacity.location.resultObject
                    d[prl.active.columnName] = true;
                    d[prl.busId.columnName] = capacity.busId.value
                    d[prl.busName.columnName] = capacity.busName.value
                    d[prl.busLatitude.columnName] = location.latitude.value
                    d[prl.busLongitude.columnName] = location.longitude.value
                    d[prl.congestionLevel.columnName] =  capacity.congestionLevel.value
                    d[prl.currentLoad.columnName] = capacity.currentPassengers.value
                    d[prl.maxCapacity.columnName] = capacity.maxPassengers.value
                    d[prl.createdKey.columnName] = PeakMapConfig.formatDateNow()
                    d[prl.createdAt.columnName] = Date.now()
                    d[prl.routeName.columnName]= location.routeName.value


                    processBusData(d)
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
            CapacityLoadType{
                id: ba
                onCaptureData: {
                    if(hasBus && busId=== ba.busId){
                        var d = {};

                        let location = ba.location.resultObject
                        d[prl.active.columnName] = true;
                        d[prl.busId.columnName] = ba.busId.value
                        d[prl.busName.columnName] = ba.busName.value
                        d[prl.busLatitude.columnName] = location.latitude.value
                        d[prl.busLongitude.columnName] = location.longitude.value
                        d[prl.congestionLevel.columnName] =  ba.congestionLevel.value
                        d[prl.currentLoad.columnName] = ba.currentPassengers.value
                        d[prl.maxCapacity.columnName] = ba.maxPassengers.value
                        d[prl.createdKey.columnName] = PeakMapConfig.formatDateNow()
                        d[prl.createdAt.columnName] = Date.now()
                        d[prl.routeName.columnName]= location.routeName.value
                        processBusData(d)
                    }

                    /*

                    loadBar.currentPassenger = ba.currentPassengers.value
                    numPassenger.passenger = ba.currentPassengers.value

                    loadBar.congestionLevel= ba.congestionLevel.value
                    var lastModel =  routeBus.model
                    lastModel[0].route = ba.location.resultObject.routeName.value

                    routeBus.model =[]
                    routeBus.model = lastModel
                    if(location.routeName.value){
                        map.addPin(location.latitude.value, location.longitude.value,busActivity.busId, loadBar.congestionLevel)
                    }
                    */
                }
            }
        }
        onDelegateReturn:  (d)=> d.captureData()

    }

    GetAnalytics{
        id: ga
        onDelegateReturn: (c)=>c.captureData()
        dataItem: Component{
            AnalyticsResponseType{
                id: analytics
                onCaptureData: {
                   var ds = []
                    ds.push(analytics.value.value)
                    chartScreen.dataSets=[]
                    chartScreen.dataSets=ds
                    chartScreen.chartLabels =[]
                    chartScreen.chartLabels = analytics.record.value
                    chartScreen.change = analytics.changes.value
                }
            }
        }
    }
    GetStationLoadRank{
        id :stationLoadRank


    }
    function customSlice(arr) {
      const result = [];
      var skips = arr.length / 20
      let index =0
      while(index < arr.length){
          result.push(arr[index])
          index += Math.floor(skips);
          console.log(skips , index)
      }

      return result;
    }

    function reorder(points) {
        points.sort(function(a, b) {
              return a.lon === b.lon ? a.lat - b.lat : a.lon - b.lon;
          });

          function cross(o, a, b) {
              return (a.lon - o.lon) * (b.lat - o.lat) - (a.lat - o.lat) * (b.lon - o.lon);
          }

          var lower = [];
          for (var i = 0; i < points.length; i++) {
              while (lower.length >= 2 && cross(lower[lower.length-2], lower[lower.length-1], points[i]) <= 0) {
                  lower.pop();
              }
              lower.push(points[i]);
          }

          var upper = [];
          for (var j = points.length - 1; j >= 0; j--) {
              while (upper.length >= 2 && cross(upper[upper.length-2], upper[upper.length-1], points[j]) <= 0) {
                  upper.pop();
              }
              upper.push(points[j]);
          }

          upper.pop();
          lower.pop();
          return lower.concat(upper);
    }


    GetHeatMap{
        id: ghm
        dataItem:  Component{
            GetHeatMapModel{
                id: ghmm


            }
        }
        onArrayReturn: (data)=>{
           //dont add low
            var pushed = []
            data.forEach((item)=>{
                if(item.congestion !== "LOW"){
                    pushed.push(item)
                }
            })
            heatmapType.heatMapPoints = []
            heatmapType.heatMapPoints = pushed
            acOps.instance(PeakMapConfig.db.useTable(ac.tableName))
            pushed.forEach((item)=>{
                acOps.clear()
                var filter= {}
                filter[ac.createdKey.columnName] = PeakMapConfig.formatDateNow()
                filter[ac.latitude.columnName] = item.target.latitude
                filter[ac.longitude.columnName] = item.target.longitude
                acOps.filter(filter)
                acOps.runQuery((data)=>{
                    if(data.length > 0){
                        var first = data[0]
                        first[ac.level.columnName] = item.congestion
                        acOps.update(first)
                    }else{
                        var d= {}
                        d[ac.createdAt.columnName] = Date.now()
                        d[ac.createdKey.columnName] = PeakMapConfig.formatDateNow()
                        d[ac.latitude.columnName] = item.target.latitude
                        d[ac.longitude.columnName] = item.target.longitude
                        d[ac.level.columnName] = item.congestion
                        d[ac.routeName.columnName] = item.routeName
                        acOps.insert(d)
                    }
                    updateAlerts()
                },true)

            })
        }
    }
    CongestionReporter{
        id: congestionReporter

    }
    SQLiteOperation{
        id: sqliteOps
    }

    PassengerRideLog{
        id: prl

    }

    AlertCongestion{
        id: ac
    }
    SQLiteOperation{
        id: acOps
    }

    function addHeatMap(data){

        var currentHeatMap = heatmapType.heatMapPoints
        var existIndex = currentHeatMap.findIndex(doc=> doc.target.latitude === data.target.latitude &&
                                              doc.target.longitude === data.target.longitude)
        if(existIndex > -1){

            currentHeatMap[existIndex].congestion = data.congestion
        }else{
            currentHeatMap.push(data)
        }
        heatmapType.heatMapPoints= []
        heatmapType.heatMapPoints = currentHeatMap
    }


    GetTodayBusActivity{
        id: gtba
         dataItem: Component{
             BusActivity{}
         }

        onArrayReturn: (data)=>{
            console.log("GET TODAY BUS ACTIVITY ",
                        JSON.stringify(data))
            for(var i=0; i < data.length; i++){
                    var bus = data[i]
                    sendBusActivity(bus.busId,
                                    {
                                        latitude : bus.currentLocation.latitude,
                                        longitude: bus.currentLocation.longitude
                                    },
                                    bus.congestionLevel)
            }
        }
    }

    Popup{
        id: exitPassengerPopup
        modal:true
        parent: Overlay.overlay
        width: parent.width
        height: parent.height
        background: Rectangle
        {
            color:"#80FFFFFF"
        }
        Frame{
            anchors.centerIn: parent
            width: parent.width -48
            height: 200
            background: Rectangle{
                radius: 4
            }
            ColumnLayout{
                 anchors.fill: parent
                 Item{
                     Layout.fillWidth: true
                     Layout.fillHeight: true
                    Text{
                        text:"Our system detected that you are 50 meters away from your current bus, and you have been automatically recorded as exited."
                        width: parent.width - 24
                        anchors.centerIn: parent
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.weight: 500
                    }
                 }
                 Item{
                     Layout.fillWidth: true
                     Layout.preferredHeight: 40
                     Button{
                         width: 150
                         height: 35
                         text:"Okay"
                         anchors.right: parent.right
                         anchors.verticalCenter: parent.verticalCenter
                         rightInset: 16
                         leftInset: 16
                         onClicked: {
                             exitPassengerPopup.close()
                         }
                     }
                 }
            }

        }
    }
}
