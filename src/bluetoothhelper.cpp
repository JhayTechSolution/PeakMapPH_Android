#include "bluetoothhelper.h"

#include <QDebug>
#include <QBluetoothLocalDevice>

#ifdef Q_OS_ANDROID
#include <QJniObject>
#include <QJniEnvironment>
#include <QCoreApplication>
#endif

BluetoothHelper::BluetoothHelper(QObject *parent)
    : QObject(parent)
{
}
void BluetoothHelper::ensureBluetoothEnabled()
{
    QBluetoothLocalDevice localDevice;

    if (!localDevice.isValid()) {
        qWarning() << "This device does not support Bluetooth.";
        return;
    }

    if (localDevice.hostMode() == QBluetoothLocalDevice::HostPoweredOff) {
#ifdef Q_OS_ANDROID
        qDebug() << "Requesting user to enable Bluetooth...";

        QJniObject action = QJniObject::fromString("android.bluetooth.adapter.action.REQUEST_ENABLE");
        QJniObject intent("android/content/Intent", "(Ljava/lang/String;)V", action.object<jstring>());

        QJniObject activity = QJniObject::callStaticObjectMethod(
            "org/qtproject/qt/android/QtNative",
            "activity",
            "()Landroid/app/Activity;"
            );

        if (activity.isValid()) {
            // ✅ Use QJniEnvironment for precise JNI call
            QJniEnvironment env;
            jclass activityClass = env->GetObjectClass(activity.object<jobject>());
            jmethodID startActivityMethod = env->GetMethodID(
                activityClass,
                "startActivity",
                "(Landroid/content/Intent;)V"
                );

            if (startActivityMethod) {
                env->CallVoidMethod(activity.object<jobject>(), startActivityMethod, intent.object<jobject>());
                qDebug() << "Bluetooth enable intent sent.";
            } else {
                qWarning() << "Could not find startActivity method.";
            }

            env->DeleteLocalRef(activityClass);
        } else {
            qWarning() << "Could not retrieve Android Activity.";
        }
#else
        qDebug() << "Bluetooth request not supported on this platform.";
#endif
    } else {
        qDebug() << "Bluetooth already enabled.";
        emit bluetoothEnabled();
    }
}
