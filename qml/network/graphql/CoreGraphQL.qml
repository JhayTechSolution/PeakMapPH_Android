import QtQuick 2.15
import "../../"
import PeakMapPHApp
QtObject{
    property string methodName
    property CoreInput queryInput:CoreInput{}
    property CoreResponse queryResponse:CoreResponse
    property bool hasInput: false
    property bool noReturnObject: false
    property string graphqlType: GraphQLType.queryType
    id: root
    signal delegateReturn(var item)
    signal arrayReturn(var array)
    function createQuery(){

        var res = "";
            console.log(methodName)
        if(!noReturnObject){

            res = queryResponse.createResponse()
        }
        console.log("DONE RESPONSE GEN")
        if(hasInput){
            console.log('GENERATE INPUT ',queryInput)
            console.log(JSON.stringify(queryInput))
            var val =queryInput.createInput()
            console.log("DONE INPUT")

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
                                if(root.dataItem !==null){
                                    if(Array.isArray(data)){
                                        for(var i=0; i < data.length; i++){
                                            var current = data[i]
                                             var comp = dataItem.createObject()
                                             comp.parse(current)
                                            delegateReturn(comp)
                                        }
                                        arrayReturn(data)
                                    }else{
                                        var c=dataItem.createObject()
                                        c.parse(data)
                                        delegateReturn(c)
                                    }

                                }
                                arrayReturn(data)

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
            console.log(PeakMapConfig.backend_api)
           xhr.onreadystatechange = function() {
               console.log(xhr.readyState, xhr.responseText)
               if (xhr.readyState === XMLHttpRequest.DONE) {
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
                                       delegateReturn(comp)
                                   }
                                   arrayReturn(data)
                               }else{
                                   var c=dataItem.createObject()
                                   c.parse(data)
                                   delegateReturn(c)
                               }

                           }
                           try{
                               cb(true, data)
                           }catch(err){
                               console.log(err , xhr.responseText)
                           }
                       }


                   } else {
                       console.log(xhr.responseText)
                       cb(false, "Error getting the data")
                   }
               }
           }

           // Build request body
           try{
               var body = {
                   query: createQuery(),  // <-- the query string
                   variables: hasInput ? queryInput.createInput() : {} // optional
            };
             console.log(JSON.stringify(body))

               xhr.send(JSON.stringify(body).trim("\n"));   // send as JSON
           }catch(err){
               console.log(err)
               throw new Error("Error")
           }
       }


    property Component dataItem: null
}
