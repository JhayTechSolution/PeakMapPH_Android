import QtQuick 2.15
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
Popup{
    width: parent.width
    height: parent.height
    modal: true
    parent: Overlay.overlay
    background: Rectangle{
        color:"#80FFFFFF"
    }
    id: root
    BusyIndicator{
        anchors.centerIn: parent
        width: 40
        height: 40
        layer.enabled: true
        layer.effect: ColorOverlay{
            color:"white"
        }
        running : root.visible

    }
}
