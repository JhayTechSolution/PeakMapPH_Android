import QtQuick
import QtQuick.Controls
import PeakMapPHApp
import Com.Plm.PeakMapPH 1.0
Item{
    property int currentIndex
    onCurrentIndexChanged: {
        console.log(currentIndex)
    }

    id: mSwipe

    function reloadView(){
         console.log('reloading')
       //
         console.log('destroying')
         mSwipe.children =""
         if(PeakMapConfig.id === "" || PeakMapConfig.login_user ===""){
             if(PeakMapService.currentService !== null){

              mSwipe.children.forEach((item)=>{
                    try{
                      item.destroy()
                    }catch(err){}
                })
             }
             Qt.callLater(()=>{
                try{
                                  var swipe1 = nonSessionPage.createObject(mSwipe)
                              console.log(swipe1, "CREATED ")
                              swipe1.anchors.fill = mSwipe

                }  catch(err){
                                console.log(err)
                              }
            })
         }else{
            var swip2 =sessionPage.createObject(mSwipe)
             swip2.anchors.fill = mSwipe
        }



    }
    Component{
        id: sessionPage
        Item{



            SwipeView{
                anchors.fill: parent
                interactive: false
                currentIndex:  mSwipe.currentIndex
                DriverScreen{
                    onServiceCreatedData: {
                        mSwipe.currentIndex++
                        PeakMapConfig.currentService.sendData( PeakMapConfig.aesHelper.encrypt(JSON.stringify({
                            action: 'connected'
                        })))
                        das.reposition()
                    }
                    onAlight:{
                        das.alight()
                    }
                    onOnboarded:{
                        das.onboarded()
                    }

                }
                DriverActivityScreen{
                    id: das
                }

            }
        }
    }
    Component{
        id: nonSessionPage
        Item{
            SwipeView{
                anchors.fill: parent
                interactive: false
                currentIndex:  mSwipe.currentIndex
                DashboardPage{
                    id: mDashboard
                }
                ReportPage{
                    id: mReportPage
                }
                AlertPage{
                    id: mAlertPage
                }
                AboutPage{}
            }

            Component.onCompleted: {
                baua.subscribe()
                stationLoad.subscribe()

                cus.subscribe()
                mDashboard.startLoad()
                mReportPage.startLoad()
            }

            BusActivityUpdateAll{
                id:  baua
                dataItem: Component{
                    BusActivity{
                        id: bus
                        onCaptureData: {
                             mDashboard.sendBusActivity(bus.busId.value,
                                                       {
                                                         latitude : bus.currentLocation.resultObject.latitude.value,
                                                         longitude: bus.currentLocation.resultObject.longitude.value
                                                       },
                                                       bus.congestionLevel.value)
                        }
                    }
                }
                onDelegateReturn:  (c)=> c.captureData()
            }


            StationLoadUpdateSubscription{
                id :stationLoad
                onArrayReturn: (data)=>{
                    mDashboard.sendLoadRank(data)

                }

            }
            TriggerStationUpdate{
                id: tsu

            }

            CongestionUpdateSubscription{
                id: cus
                onArrayReturn: (data)=>{
                    mDashboard.addHeatMap({
                        target: {
                            latitude: data.latitude,
                            longitude: data.longitude
                        },
                        congestion: data.level
                    })
                    if(data.level === "LOW"){
                        return
                    }

                    ops.instance(PeakMapConfig.db.useTable(ac.tableName));
                    let fn  ={}
                    fn[ac.createdKey.columnName] = PeakMapConfig.formatDateNow()
                    ops.filter(fn)
                    ops.limit(1)
                    ops.runQuery((data1)=>{
                        if(data1.length > 0){
                            var ndata  = data1[0]
                            console.log(JSON.stringify(ndata), JSON.stringify(data))
                            let lat = ndata[ac.latitude.columnName]
                            let lon = ndata[ac.longitude.columnName]
                            let level = ndata[ac.level.columnName]
                            if(lat === data.latitude
                               && lon === data.longitude
                               && data.level === level ){
                                console.log("ITS THE SAME ? ")
                                return
                            }
                        }
                        data[ac.createdAt.columnName] = Date.now()
                        data[ac.createdKey.columnName] = PeakMapConfig.formatDateNow()
                        ops.insert(data)
                        mAlertPage.refreshAlerts()

                    },true)



                }

            }

            AlertCongestion{
                id: ac
            }

            SQLiteOperation{
                id: ops

            }


        }
    }

    Component.onCompleted: {
        currentIndex  = 0
        PeakMapConfig.gtransport.connectServer()
        PeakMapConfig.gtransport.connectionOkay.connect(()=>{
            reloadView()
        })
    }



}
