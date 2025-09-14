#ifndef SQLITEUNIQUEKEY_H
#define SQLITEUNIQUEKEY_H

#include <QObject>
#include "sqlitekey.h"
//multiple allowed , allowed composite
class SQLiteUniqueKey : public SQLiteKey
{
    Q_OBJECT
    Q_PROPERTY(ConflictResolution conflictDetection READ getConflictDetection WRITE setConflictDetection NOTIFY conflictDetectionChanged)
public:
    explicit SQLiteUniqueKey(QObject *parent = nullptr);

    Q_INVOKABLE void setConflictDetection(ConflictResolution conflictDetection);
    ConflictResolution getConflictDetection();
private:
    ConflictResolution conflictDetection;
signals:
    void conflictDetectionChanged();
};

#endif // SQLITEUNIQUEKEY_H
