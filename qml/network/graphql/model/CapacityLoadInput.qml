import QtQuick 2.15
import "../"
CoreInput{
    property alias value: mInput.value
    property CoreInputMarker input: CoreInputMarker{
        id: mInput
        dataType: CoreType.stringType
        isRequired: true

    }
}
