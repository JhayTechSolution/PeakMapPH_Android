#ifndef PEAKVSINK_H
#define PEAKVSINK_H
#include <QZXing.h>
#include <QVideoSink>
#include <QCamera>
#include <QMediaCaptureSession>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

class PeakVSink : public QObject {
    Q_OBJECT
public:
    explicit PeakVSink(QObject *parent = nullptr)
        : QObject(parent) {
        decoder.setDecoder(QZXing::DecoderFormat_QR_CODE);
    }

public slots:
    void processFrame(const QVideoFrame &frame) {
        QImage img = frame.toImage();
        if (!img.isNull()) {
            const QString result = decoder.decodeImage(img);
            if (!result.isEmpty() && result != lastResult) {
                lastResult = result;
                emit qrFound(result);
            }
        }
    }

signals:
    void qrFound(const QString &text);

private:
    QZXing decoder;
    QString lastResult;
};

#endif // PEAKVSINK_H
