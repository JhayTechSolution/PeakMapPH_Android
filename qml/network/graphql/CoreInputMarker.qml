import QtQuick 2.15
QtObject{
    required property string dataType
    property bool _isMarker: true
    property var value //value sometimes its CoreInput
    property bool isRequired: false
    property string inputName //optional , default is the attachedProperty
}
