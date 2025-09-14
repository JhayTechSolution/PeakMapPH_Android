import QtQuick 2.15
import "../../"
QtObject{
    property string methodName
    property CoreInput queryInput:CoreInput{}
    property CoreResponse queryResponse:CoreResponse
    property bool hasInput: false
    property bool noReturnObject: false
    property string graphqlType: GraphQLType.queryType
    id: root
    signal delegateReturn(var item)
    function createQuery(){

        var res = "";
        if(!noReturnObject){
            res = queryResponse.createResponse()
        }

        if(hasInput){
            var val =queryInput.createInput()


            return graphqlType + (queryInput.getInputType().arg(methodName).arg(res)).trim("\n")
        }else{


            return  graphqlType+ "{ %1%2} ".arg(methodName).arg(res).trim("\n")
        }

    }

    function subscribe(){
        if(graphqlType !== GraphQLType.subscriptionType){
            throw new Error("Although by default it is allowed , but we limit only for Subscription type , please use sendRequest")
        }
        var body = {
            query: createQuery(),
            variables: hasInput?  queryInput.createInput():{}

        }
        let transport = PeakMapConfig.gtransport
        transport.subscribe(body, methodName, (m, data)=>{
                                console.log("RETURNED DATA", JSON.stringify(data))
                                if(root.dataItem !==null){
                                    if(Array.isArray(data)){
                                        for(var i=0; i < data.length; i++){
                                            var current = data[i]
                                             var comp = dataItem.createObject()
                                             comp.parse(current)
                                            delegateReturn(comp)
                                        }
                                    }else{
                                        var c=dataItem.createObject()
                                        c.parse(data)
                                        delegateReturn(c)
                                    }

                                }
        })
    }

    function sendRequest(cb) {
           console.log('SENDING NOTMAL REQUEST')
           if(graphqlType === GraphQLType.subscriptionType){
                throw new Error("Only query and mutation are acceptable here , use subscribe");

           }

           var xhr = new XMLHttpRequest();
           xhr.open("POST", PeakMapConfig.backend_api);
           xhr.setRequestHeader("Content-Type", "application/json");

           xhr.onreadystatechange = function() {
               if (xhr.readyState === XMLHttpRequest.DONE) {
                   console.log(xhr.status , xhr.responseText)
                   if (xhr.status === 200) {
                       var json =JSON.parse(xhr.responseText)

                       if(json.data === null && json.errors !== undefined){
                           cb(false, "Error getting the data")
                       }else{
                           var data = json.data[methodName]
                           if(root.dataItem !==null){
                               if(Array.isArray(data)){
                                   for(var i=0; i < data.length; i++){
                                       var current = data[i]
                                        var comp = dataItem.createObject()
                                        comp.parse(current)
                                        console.log(JSON.stringify(comp))
                                   }
                               }else{
                                   var c=dataItem.createObject()
                                   c.parse(data)
                                   delegateReturn(c)
                               }

                           }

                           cb(true, data)
                       }


                   } else {
                       console.log(xhr.responseText)
                       cb(false, "Error getting the data")
                   }
               }
           }

           // Build request body
           var body = {
               query: createQuery(),  // <-- the query string
               variables: hasInput ? queryInput.createInput() : {} // optional
           };

           xhr.send(JSON.stringify(body).trim("\n"));   // send as JSON
       }


    property Component dataItem: null
}
