import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
Popup{

    background: Rectangle{
        color:"#80FFFFFF"
    }
    parent: Overlay.overlay
    property alias title: mTitle.text
    property alias message: messageContent.text
    Frame{
        anchors.centerIn: parent
        width: parent.width -24
        property int minHeight: 200
        padding: 0
        leftPadding: 0
        rightPadding: 0
        bottomPadding:0
        background:Rectangle{
            radius: 8
        }

        height: mContent.height < minHeight ? minHeight: mContent.height
        ColumnLayout{
            id: mContent
            width: parent.width
            Text{
                text:"Title"
                font.pixelSize: 18
                font.weight: 700
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 24
                Layout.bottomMargin: 16
                id: mTitle
                color:"black"

            }

            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color:"#e8e8e8"
            }
            Text{

                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.topMargin: 16
                anchors.centerIn: parent
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color:"black"
                id: messageContent
            }
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color:"#e8e8e8"
            }

            Button{
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 24
                Layout.bottomMargin: 24
                Layout.topMargin: 16
                text:"Ok"
                onClicked: ctrl.close()
            }
        }
    }
    id: ctrl
}
