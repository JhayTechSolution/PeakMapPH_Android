import QtQuick
import QtMultimedia
import QtQuick.Controls
import Com.Plm.PeakMapPH 1.0
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent

    // === Signals & properties ===
    property var lastCapture: null
    property bool active: false
    property Item mVsink

    signal qrCaptured(var qrData)
    signal requestClosed()

    // === Camera ===
    Camera {
        id: mCamera
        focusMode: Camera.FocusModeInfinity

        active:true
        onErrorOccurred: (error, errorString) => {
            console.warn("Camera error:", error, errorString)
            restart()
        }
    }

    CaptureSession {
        id: captureSession
        camera: mCamera
        videoOutput: videoOutput
    }

    VideoOutput {
        id: videoOutput
        width: root.width + 200
        height: root.height
        focus: true
        fillMode: VideoOutput.Stretch
    }

    // === QR capture overlay ===
    Rectangle {
        id: captureRect
        anchors.centerIn: parent
        width: 300
        height: 280
        color: "transparent"
        border.color: "red"
        border.width: 2
        Rectangle{
            width: parent.width
            height: 2
            color:"green"
            id:scannerIndicator
            Component.onCompleted: {
                downScan.start()
            }
        }
        PropertyAnimation{
            id:  downScan
            from: 2
            to: captureRect.height -2
            target: scannerIndicator
            property: "y"

            easing: Easing.InQuad
            duration: 800
            onFinished: {
                upScan.start()
            }
        }
        PropertyAnimation{
            onFinished: {
                downScan.start()
            }

            id: upScan
            from: captureRect.height-2
            to: 2
            target: scannerIndicator
            property:"y"
            duration: 800
            easing: Easing.InQuad

        }
    }

    // === QR Decoder (persistent) ===
    PeakQRDecoder {
        id: pvsink
        videoSink: videoOutput.videoSink
        videoOutput: Qt.rect(videoOutput.x, videoOutput.y, videoOutput.width, videoOutput.height)
        captureRect: Qt.rect(captureRect.x, captureRect.y, captureRect.width, captureRect.height)

        onVideoSinkChanged: console.log("VIDEO SINK CHANGED", videoSink)

        onQrDecoded: (capture) => {
            if(capture === null) return
            if(capture === root.lastCapture) return
            console.log("DECODED ", capture  , typeof(capture))
            root.qrCaptured(capture)
            root.lastCapture = capture
        }

        onOutputInvalid: {
            console.log("Output invalid — restarting camera")
            root.restart()
        }
    }

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: false
        property var callback
        onTriggered: callback?.call(this)
    }

    function setTimeout(callback, time) {
        timer.callback = callback
        timer.interval = time
        timer.start()
    }

    function paused() {
        Qt.callLater(()=>{
                         try{
                             mCamera.active = false
                         }catch(err){
                             console.log(err)
                         }

                     })
    }

    function resume() {
        lastCapture = null
        // set preferred format once
        for (var i = 0; i < mCamera.cameraDevice.videoFormats.length; i++) {
            var fmt = mCamera.cameraDevice.videoFormats[i]
            console.log("Available format:", fmt.resolution.width, "x", fmt.resolution.height)
            if (fmt.resolution.width === 960 && fmt.resolution.height === 720) {
                mCamera.cameraFormat = fmt
                break
            }
        }
        mCamera.active=false
        mCamera.active = true
        mCamera.start()
    }

    function restart() {
        paused()
        setTimeout(() => {
            console.log("Reopening camera")
            resume()
        }, 300)
    }

}
