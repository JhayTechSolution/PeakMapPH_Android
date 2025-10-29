import QtQuick 2.15

QtObject{
    id : root
    property bool _isMarker: true
    property bool include: true
    required property string dataType
    property CoreResponse resultObject: CoreResponse{}
    property var value
    property string propertyName //optional but default to property declared
}
