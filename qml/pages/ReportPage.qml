import QtQuick
import Felgo
import QtQuick.Layouts
import QtQuick.Controls
Item {

    id: item
    property int selectIndex:0

    Flickable{
        anchors.fill: parent
        contentHeight: mContent.height
        ColumnLayout{
            id:mContent
            width: parent.width
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color:"#3A4650"
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 16
                radius: 8
                RowLayout{
                    anchors.fill: parent
                    Repeater{
                        model:["Daily", "Weekly","Monthly"]
                        id:mRepeater
                        delegate: Rectangle{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.margins: 10
                            radius: 8
                            color: (selectIndex === index) ? "black":"transparent"
                            Text{
                                text:modelData
                                font.pixelSize: 18
                                anchors.centerIn: parent
                                color:"white"
                                font.weight: (selectIndex === index)? 700:500
                            }

                            MouseArea{
                                anchors.fill: parent

                                onClicked:{
                                    selectIndex = index
                                }
                            }
                        }
                    }
                }
            }

            Frame{
                Layout.fillWidth: true

                Layout.preferredHeight: 450
                Layout.leftMargin: 24
                Layout.topMargin: 16
                Layout.rightMargin: 24
                topPadding:24
                leftPadding:16
                rightPadding:16
                bottomPadding:24
                background:Rectangle{
                    color:"transparent"
                    border.width: 1
                    radius: 8
                    border.color: "#383838"
                }
                ColumnLayout{
                    anchors.fill: parent
                    Text{
                        text:"Ridership Trend"
                        color:"white"
                        font.pixelSize: 16
                        font.weight: 600
                    }
                    Text{
                        text:"12%"
                        font.pixelSize: 30
                        color:"white"
                        font.weight: 900
                    }
                    Text{
                        text:"Last 7 days <m style='color:green'>12%</m>"
                        font.pixelSize: 14
                        color:"#888888"
                        textFormat: Text.MarkdownText
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }

            }

            Frame{
                Layout.fillWidth: true
                Layout.preferredHeight: 350
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 16

                topPadding:24
                leftPadding:16
                rightPadding:16
                bottomPadding:24
                background:Rectangle{
                    color:"transparent"
                    border.width: 1
                    border.color: "#383838"
                    radius:8
                }
                ColumnLayout{
                    anchors.fill: parent
                    Text{
                        text:"Peak Hours"
                        font.pixelSize:16
                        font.weight: 600
                        color:"white"
                    }
                    Text{
                        text:"30%"
                        font.pixelSize: 30
                        font.weight: 900
                        color:"white"
                    }
                    Text{
                        text:"Last 7 days <m style='color:green'>8%</m>"
                        font.pixelSize: 14
                        color:"#888888"
                        textFormat: Text.MarkdownText
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }
            Frame{
                Layout.fillWidth: true
                Layout.preferredHeight: 450
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 16

                topPadding:24
                leftPadding:16
                rightPadding:16
                bottomPadding:24
                background:Rectangle{
                    color:"transparent"
                    border.width: 1
                    border.color: "#383838"
                    radius:8
                }
                ColumnLayout{
                    anchors.fill: parent
                    Text{
                        text:"Bottleneck Areas"
                        font.pixelSize:16
                        font.weight: 600
                        color:"white"
                    }
                    Text{
                        text:"15%"
                        font.pixelSize: 30
                        font.weight: 900
                        color:"white"
                    }
                    Text{
                        text:"Last 7 days <m style='color:green'>15%</m>"
                        font.pixelSize: 14
                        color:"#888888"
                        textFormat: Text.MarkdownText
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

        }
    }

}
