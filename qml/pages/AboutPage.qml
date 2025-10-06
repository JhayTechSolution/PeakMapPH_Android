import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Item {

    ColumnLayout{
        anchors.centerIn: parent
        width: parent.width - 48
        spacing: 24

        Image{
            Layout.alignment: Qt.AlignHCenter
            source:"../../assets/peakmap.webp"
        }

        Text{
            text:"About PeakMapPH"
            Layout.alignment: Qt.AlignCenter
            color:"white"
            font.pixelSize: 30
            font.weight: 700
            font.family: "Roboto"
        }

        Text{

            textFormat: Text.MarkdownText
            text:{
                return `
            <p>
                  PeakMapPH is a <span style="color:#00FFFF; font-weight:bold;">real-time commuter load monitoring platform</span>
                  created for the EDSA Carousel Bus System.
                </p>
            <p>
               Developed by students at <span style="color:#00FFFF; font-weight:bold;">Pamantasan ng Lungsod ng Maynila</span>,
               our goal is to help solve persistent issues like
               <i>overcrowding, long queues,</i> and
               <i>inconsistent wait times</i> on the EDSA Carousel.
             </p>`.trim()
            }

            wrapMode: Text.WordWrap
            color:"white"
            Layout.preferredWidth:  parent.width

        }
    }
}
