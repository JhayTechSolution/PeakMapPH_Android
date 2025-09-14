#include "peakqrdecoder.h"
#include <QDebug>
#include <QThread>
#include <QtConcurrent/QtConcurrent>
#include <QBuffer>
#include <QQuickItemGrabResult>
#include <QSharedPointer>
PeakQrDecoder::PeakQrDecoder(QObject *parent)
    : QObject{parent}
{

    auto worker = new QrWorker;
    worker->moveToThread(&m_workerThread);
    connect(&m_workerThread, &QThread::finished, worker, &QObject::deleteLater);

    connect(this, &PeakQrDecoder::newImage, worker, &QrWorker::decodeImage, Qt::QueuedConnection);
    connect(worker, &QrWorker::decoded, this, [this](const QString &res) {
        m_busy = false;
        emit qrDecoded(res);
    });
    connect(worker, &QrWorker::noResult, this, [this](){
        m_busy = false;

    });

    m_workerThread.start();

}

PeakQrDecoder::~PeakQrDecoder(){


    m_workerThread.quit();
    m_workerThread.wait();



}

void PeakQrDecoder::setVideoSink(QVideoSink *vSink){

    if(this->m_sink == vSink){
        return;
    }

    this->m_sink = vSink;
    if(this->m_sink){
        disconnect(this->m_sink,&QVideoSink::videoFrameChanged, this , &PeakQrDecoder::onVideoFrame);
                connect(this->m_sink, &QVideoSink::videoFrameChanged, this ,&PeakQrDecoder::onVideoFrame);
    }


    emit this->videoSinkChanged();
}


QVideoSink *PeakQrDecoder::videoSink(){

    return this->m_sink;
}

void PeakQrDecoder::release(){
    this->m_busy=false;
}


void PeakQrDecoder::onVideoFrame(const QVideoFrame &frame)
{
    if (!frame.isValid()) {
        qDebug() << "VideoFrame is not valid!";
         return;
    }

    if (this->m_busy)
        return;

    this->m_busy = true;

    QImage img = frame.toImage();
    if (img.isNull()) {
        emit this->outputInvalid();
        this->m_busy = false;
        return;
    }

    img = img.convertToFormat(QImage::Format_RGBA8888_Premultiplied);

    auto videoOutputSize = m_videoOutput.value<QRectF>();
    auto capture = m_captureRect.value<QRectF>();

    img = img.scaled((int) videoOutputSize.width(), (int) videoOutputSize.height());
    if (img.isNull()) {
        emit this->outputInvalid();
        this->m_busy = false;
        return;
    }

    // --- Black/White detection ---
    bool allBlack = true;
    bool allWhite = true;

    for (int y = 0; y < img.height() && (allBlack || allWhite); ++y) {
        const QRgb *line = reinterpret_cast<const QRgb*>(img.constScanLine(y));
        for (int x = 0; x < img.width() && (allBlack || allWhite); ++x) {
            QColor c(line[x]);
            if (c.red() != 0 || c.green() != 0 || c.blue() != 0) {
                allBlack = false;
            }
            if (c.red() != 255 || c.green() != 255 || c.blue() != 255) {
                allWhite = false;
            }
        }
    }

    if (allBlack) {
        qWarning() << "Frame is completely black!";
        emit this->outputInvalid();
        this->m_busy = false;
        return;
    }
    if (allWhite) {
        qWarning() << "Frame is completely white!";
        emit this->outputInvalid();
        this->m_busy = false;
        return;
    }
    // --- End detection ---
    QImage captureCropped = img.copy(capture.x(), capture.y(), capture.width(), capture.height());

    emit this->newImage(captureCropped);
    // emit this->videoSinkImage(QVariant::fromValue(captureCropped));

    this->m_busy = false;
}



void PeakQrDecoder::grab(QQuickItem *item){
    if (!item) return;

    auto grabResult = item->grabToImage();
    QObject::connect(grabResult.data(), &QQuickItemGrabResult::ready, [grabResult]() {
        QImage img = grabResult->image();
        if (!img.isNull()) {
            qDebug() << "Grabbed image size:" << img.size();
            // Now you can pass it to QZXing:
            // qrDecoder->decodeImage(img);
        }
    });
}


void PeakQrDecoder::setVideoOutput(QVariant videoOutput){
    this->m_videoOutput  = videoOutput;
    emit this->videoOutputChanged();
}
void PeakQrDecoder::setCaptureRect(QVariant captureRect){
    this->m_captureRect = captureRect;
    emit this->captureRectChanged();
}

QVariant PeakQrDecoder::videoOutput(){ return this->m_videoOutput;}
QVariant PeakQrDecoder::captureRect(){ return this->m_captureRect; }


