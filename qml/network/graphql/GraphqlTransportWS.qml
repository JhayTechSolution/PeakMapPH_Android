import QtQuick 2.15
import QtWebSockets
import "../../"
WebSocket{
    requestedSubprotocols :["graphql-transport-ws"]
    url:PeakMapConfig.backend_api.replace("http://","ws://").replace("https://","wss://")
    active: false
    property int lastId: 0
    property var callbacks: [] // {id,callback}
    property bool handshaked:false
    signal connectionOkay()
    onStatusChanged:  (ws)=>{
         if(status == WebSocket.Open){
            console.log('open')
            sendTextMessage(JSON.stringify({ type: "connection_init", payload: {} }))

        }else if(status === WebSocket.Closed || status === WebSocket.Closing){
            handshaked =false
        }
    }
    onTextMessageReceived: (msg)=>{
        console.log("TEXT MESSAGE ",msg)
        var res = JSON.parse(msg)
        if(!handshaked){
            if(res.type === "connection_ack"){
                handshaked=true
                connectionOkay()
                return

            }
        }
        if(res.type === "next"){
            var resId = parseInt(res.id)
            var subs = getSubscriptionById(resId)
            if(!subs){
                console.log("Theres nothing in the memory to callback with this event")
                return
            }

            var payload = res.payload["data"][subs.methodName]
            subs.callback(subs.methodName , payload)
        }



    }

    function connectServer(){
        if(active){
            return
        }

        active = false
        Qt.callLater(()=> { active = true } )
    }

    function disconnectServer(){
        if(active){
            active= false
        }
    }

    function subscribe(payload, methodName,  callback){

        console.log('sending text message')
        lastId +=1
        var json ={
            id: lastId.toString(),
            type: "subscribe",
            payload
        }
        console.log(JSON.stringify(json))
        sendTextMessage(JSON.stringify(json))
        console.log("subscribed!")
        callbacks.push({
                       id: lastId ,
                        methodName,
                        callback
                       })

    }
    function getSubscriptionById(id){
        for(var i=0; i < callbacks.length; i++){
            var current = callbacks[i]
            if(current.id === id ){
                return current
            }
        }
        return null
    }

    function getSubscription(methodName){
        for(var i=0; i < callbacks.length; i++){
            var current = callbacks[i]
            if(current.methodName === methodName){
                return current
            }
        }
        return null
    }
    function unsubscribe(methodName){
        var subs = getSubscription(methodName)
        if(!subs){
            throw new Error("Nothing to unsubscribe")
        }
        var js = {
            id: subs.id.toString() ,
            type: "complete"
        }
        sendTextMessage(JSON.stringify(js))

    }
}
