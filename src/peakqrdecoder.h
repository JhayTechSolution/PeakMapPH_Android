#ifndef PEAKQRDECODER_H
#define PEAKQRDECODER_H

#include <QObject>
#include <QVideoSink>
#include <QVideoFrame>
#include <QZXing.h>
#include <QThread>
#include <QQuickItem>
class QrWorker : public QObject
{
    Q_OBJECT
public:
    explicit QrWorker(QObject *parent = nullptr) : QObject(parent)
    {
        decoder = new QZXing(this);
         decoder->setDecoder(QZXing::DecoderFormat_QR_CODE | QZXing::DecoderFormat_EAN_13);
         decoder->setTryHarderBehaviour(QZXing::TryHarderBehaviour_ThoroughScanning | QZXing::TryHarderBehaviour_Rotate);

    }

public slots:
    void decodeImage(const QImage &img)
    {
        QString result = decoder->decodeImage(img);

        if (!result.isEmpty()){
            emit decoded(result);
        }else{
            emit noResult();
        }
    }

signals:
    void decoded(const QString &result);
    void noResult();
private:
    QZXing *decoder = nullptr;
};

class PeakQrDecoder : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVideoSink *videoSink READ videoSink WRITE setVideoSink NOTIFY videoSinkChanged)
    Q_PROPERTY(QVariant videoOutput READ videoOutput WRITE setVideoOutput NOTIFY videoOutputChanged)
    Q_PROPERTY(QVariant captureRect READ captureRect WRITE setCaptureRect NOTIFY captureRectChanged)
public:
    using QObject::QObject;
    explicit PeakQrDecoder(QObject *parent = nullptr);
    ~PeakQrDecoder();
    QVideoSink *videoSink();
    void setVideoSink(QVideoSink *videoSink);
    Q_INVOKABLE void release();
    Q_INVOKABLE void grab(QQuickItem *item);
    Q_INVOKABLE void setVideoOutput(QVariant videoOutput);
    Q_INVOKABLE void setCaptureRect(QVariant captureRect);
    QVariant videoOutput();
    QVariant captureRect();


signals:
    void videoOutputChanged();
    void captureRectChanged();
    void videoSinkChanged();
    void newImage(const QImage &img);
    void qrDecoded(const QString &result);
    void videoSinkImage(QVariant variant);
    void outputInvalid();

private slots:
    void onVideoFrame(const QVideoFrame &frame);

private:
    QVariant m_videoOutput;
    QVariant m_captureRect;
    QVideoSink *m_sink = nullptr;
    QThread m_workerThread;
    bool m_busy = false;

    QImage lastFrame;
};

#endif // PEAKQRDECODER_H
