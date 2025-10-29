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
    function _isArray(coreType){
        return coreType.startsWith("[") && coreType.endsWith("]")
    }
    function attachedPropName(currentProp){
        var propName = root[currentProp].propertyName
        if (propName.length > 0){
            return propName
        }
        return currentProp

    }

    function createResponse(nextLevel = false ){
        var responseProp = []

        var props = Object.keys(this)
        for(var i=0; i < props.length; i++){
            var currentProp =props[i]
            if(root._isMarker(currentProp)){
                if(root[currentProp].include){
                    if(root[currentProp].dataType === undefined || root[currentProp].dataType === null){

                        throw new Error("one of the marker has no datatype ")
                    }


                    var propName = root.attachedPropName(currentProp)
                    if(!root._isCoreType(root[currentProp].dataType)){
                        var resultObject = root[currentProp].resultObject;
                        responseProp.push("%1%2".arg(propName).arg(root[currentProp].resultObject.createResponse(true)))
                    }else{

                            responseProp.push(propName)

                    }
                }
            }
        }
        if(responseProp.length === 0) return ""
        return "{ %1 }".arg(responseProp.join(","))
    }

    function aliasProp(resProp){

        var keys =Object.keys(this)
        try{
            for(var i=0; i < keys.length; i++){
                var prop= keys[i];
                if(typeof root[prop]==="object"){
                    if (Object.keys(root[prop]).indexOf('propertyName') > -1){

                        if(prop === resProp){
                            return resProp
                        }
                        var propertyName = root[prop]['propertyName']

                        if(propertyName.length > 0){
                            if(propertyName ===  resProp){

                                return prop
                            }
                        }
                    }
                }
            }

        }catch(err){
            console.log('PROPERTY ERR',err)
        }
        return resProp
    }

    function parse(data){
        var props = Object.keys(data)
        try{
            for(var i=0; i < props.length; i++){
                var dataProp = props[i]
                var currentProp = aliasProp(dataProp)
                console.log('PROPERTY ', currentProp)
                if(root._isMarker(currentProp)){
                    var dt = root[currentProp].dataType.replace("!","")
                    if(root[currentProp].include){
                    if(root._isCoreType(dt)){
                        root[currentProp].value = data[dataProp]
                    }else if(root._isArray(dt)){
                         dt = dt.replace("[","").replace("]","")
                        var value = data[dataProp]
                        root[currentProp].value = []
                        for(var x=0; x < value.length; x++){
                            if(root[currentProp].include){
                            if(root._isCoreType(dt)){
                                root[currentProp].value.push(value[x])
                            }else{

                                var obj = root[currentProp].resultObject.parse(value[x])
                                root[currentProp].value.push(obj)
                            }
                            }
                        }
                    }else{
                          root[currentProp].value = root[currentProp].resultObject.parse(data[dataProp])
                    }
                    }
                }
            }
        }catch(err){
            console.log("This is not the expected data" , err, JSON.stringify(props))
        }
    }
    signal captureData()

}
