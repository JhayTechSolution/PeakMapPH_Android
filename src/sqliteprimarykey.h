#ifndef SQLITEPRIMARYKEY_H
#define SQLITEPRIMARYKEY_H

#include <QObject>
// defining 2 primary key allowd when its composite but not separate declaration
//auto increment will not work for composite

#include "sqlitekey.h"
class SQLitePrimaryKey : public SQLiteKey
{
    Q_OBJECT
    Q_PROPERTY(bool autoIncrement READ isAutoIncremented WRITE setAutoIncrement NOTIFY autoIncrementChanged)

    Q_PROPERTY(ConflictResolution conflictDetection READ getConflictDetection WRITE setConflictDetection NOTIFY conflictDetectionChanged)
public:
    explicit SQLitePrimaryKey(QObject *parent = nullptr);
    Q_INVOKABLE void setAutoIncrement(bool autoIncrement);
    Q_INVOKABLE void setConflictDetection(ConflictResolution conflictDetection);
    bool isAutoIncremented();
    ConflictResolution getConflictDetection();
private:
    bool autoIncrement; //only integer
    ConflictResolution conflictDetection;

signals:
    void autoIncrementChanged();
    void conflictDetectionChanged();
};

#endif // SQLITEPRIMARYKEY_H
