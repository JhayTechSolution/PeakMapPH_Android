import QtQuick 2.15
import "../"
CoreInput{
    property alias user: un.value
    property alias pwd: pwd.value
    property var username: CoreInputMarker{
        dataType: CoreType.stringType
        isRequired: true
        id: un
    }
    property var password: CoreInputMarker{
        dataType: CoreType.stringType
        isRequired: true
        id: pwd
    }
}
