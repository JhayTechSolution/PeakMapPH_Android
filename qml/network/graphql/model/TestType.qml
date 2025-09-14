import QtQuick 2.15
import "../"
CoreInput{
    property CoreInputMarker test1: CoreInputMarker{
        dataType: CoreType.stringType
        value:"Im a Test 1"
    }
    property CoreInputMarker test2: CoreInputMarker{
        dataType: CoreType.boolType
        value:true
        isRequired: true
    }
    property CoreInputMarker test3: CoreInputMarker{
        dataType: "Test"
        isRequired: true
        value:CoreInput{
            property CoreInputMarker test4:CoreInputMarker{
                dataType:CoreType.floatType
                value:100.0
                isRequired: true
            }
        }
    }
}
