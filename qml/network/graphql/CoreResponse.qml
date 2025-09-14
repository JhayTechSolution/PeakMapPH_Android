import QtQuick 2.15

QtObject{
    id: root

    function _isMarker(prop){
        try{
            if(root[prop]._isMarker !== undefined){
                return true
            }
            return false
        }catch(err){
            return false
        }
    }
    function _isCoreType(coreType){
        if(coreType === CoreType.stringType
            || coreType === CoreType.boolType
            || coreType === CoreType.floatType
            || coreType === CoreType.idType
            || coreType === CoreType.intType
        ){
            return true
        }
        return false
    }

    function createResponse(){
        var responseProp = []

        var props = Object.keys(this)
        for(var i=0; i < props.length; i++){
            var currentProp =props[i]
            if(root._isMarker(currentProp)){
                if(root[currentProp].include){
                    if(root[currentProp].dataType === undefined || root[currentProp].dataType === null){

                        throw new Error("one of the marker has no datatype ")
                    }


                    if(root._isCoreType(root[currentProp].dataType)){
                        console.log(root[currentProp].dataType.toString())
                        responseProp.push(currentProp)
                    }else{
                        responseProp.push("%1%2".arg(currentProp).arg(root[currentProp].resultObject.createResponse()))
                    }
                }
            }
        }
        if(responseProp.length === 0) return ""
        return "{ %1 }".arg(responseProp.join(","))
    }


    function parse(data){
        var props = Object.keys(data)
        try{
            for(var i=0; i < props.length; i++){
                var currentProp = props[i]
                if(root._isMarker(currentProp)){
                    if(root._isCoreType(root[currentProp].dataType)){
                        root[currentProp].value = data[currentProp]

                    }else{
                        console.log('NOT A CORETYPE ', JSON.stringify(data[currentProp]), currentProp , root[currentProp].resultObject)
                         root[currentProp].value = root[currentProp].resultObject.parse(data[currentProp])
                    }
                }
            }
        }catch(err){
            console.log("This is not the expected data" , err, JSON.stringify(props))
        }
    }
    signal captureData()

}
