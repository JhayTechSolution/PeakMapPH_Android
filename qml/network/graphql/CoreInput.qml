import QtQuick 2.15

QtObject{
    id : root
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
    property var _inputNames:[]
    property var _inputTypes:[]
    function createInput( ){
        _inputNames =[]
        _inputTypes = []
        var keys = Object.keys(this)
        var obj = {
        }
        for(var i=0; i < keys.length; i++){
            var currentProps = keys[i]
            if(root._isMarker(currentProps)){
                var dType = root[currentProps].dataType
                if(dType === undefined || dType === null ){
                    throw new Error("One of the input has no dataType ")
                }
                if(dType.length === 0){
                    throw new Error("One of the input has no datatype")
                }

                var inputName = root[currentProps].inputName
                if(inputName.length === 0){
                    inputName = currentProps
                }
                if(root._isCoreType(dType)){

                    obj[inputName] = root[currentProps].value

                }else{
                    try{
                        obj[inputName] = root[currentProps].value.createInput();
                    }catch(err){
                        //not an object maybe its just an enum
                        obj[inputName] = root[currentProps].value
                    }
                }
                if(root[currentProps].isRequired){
                    dType +="!"
                }
                _inputNames.push("%1:$%1".arg(inputName))
                _inputTypes.push("$%1:%2".arg(inputName).arg(dType))


            }

        }

        return obj

    }
    function getInputType(){
        return "( %1 ){
            %3(%2)%4
        }".arg(root._inputTypes.join(","))
        .arg(root._inputNames.join(","))


    }
}
