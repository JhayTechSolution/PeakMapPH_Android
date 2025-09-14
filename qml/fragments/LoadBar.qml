import QtQuick 2.15
import QtQuick.Controls
ProgressBar {
    id: progressBar
    width: parent.width - 10
    height: 8
    anchors.horizontalCenter: parent.horizontalCenter
    background: Rectangle {
        anchors.fill: progressBar
        color: "lightgreen"
        radius: 4
        border.width: 1
        border.color: Style.appBackgroundColor
    }
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 4
    value: currentProgress
    contentItem: Rectangle {
        anchors.left: progressBar.left
        anchors.bottom: progressBar.bottom
        height: progressBar.height
        width: progressBar.width * progressBar.value
        color: progressBar.value === 0.0 ? "lightgreen" : Style.appBackgroundColor
        radius: 4
    }
}
