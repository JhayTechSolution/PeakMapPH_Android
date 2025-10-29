#pragma once
#include <QByteArray>
#include <array>
#include <cstdint>
#include <QObject>
class AESHelper: public QObject {
    Q_OBJECT
    Q_PROPERTY(QString passkey READ getPasskey WRITE setPasskey NOTIFY passkeyChanged)

public:
    explicit AESHelper(QObject *parent = nullptr);

    Q_INVOKABLE QString encrypt(const QByteArray &plain);

    Q_INVOKABLE QString decrypt(const QByteArray &cipher);
    QString getPasskey();
    void  setPasskey(QString passkey);

private:
    void createPasskeyExpansion();
    QString passkey;
    void keyExpansion(const uint8_t *key);
    void aesEncryptBlock(const uint8_t *in, uint8_t *out);
    void aesDecryptBlock(const uint8_t *in, uint8_t *out);

    void subBytes(uint8_t *state);
    void invSubBytes(uint8_t *state);
    void shiftRows(uint8_t *state);
    void invShiftRows(uint8_t *state);
    void mixColumns(uint8_t *state);
    void invMixColumns(uint8_t *state);
    void addRoundKey(uint8_t *state, const uint8_t *roundKey);

    static uint8_t xtime(uint8_t x);
    static uint8_t mul(uint8_t a, uint8_t b);

    std::array<uint8_t, 176> roundKey_;

    static const uint8_t sbox[256];
    static const uint8_t rsbox[256];
signals:
    void passkeyChanged();
};
