#include "sqliteprimarykey.h"
#include "sqliteproperty.h"


SQLitePrimaryKey::SQLitePrimaryKey(QObject *parent)
    : SQLiteKey(parent),
    autoIncrement(false)  // default value, adjust as needed
{
    this->conflictDetection = ConflictResolution::ABORT;
}

void SQLitePrimaryKey::setAutoIncrement(bool autoInc)
{
    if (autoIncrement != autoInc) {
        autoIncrement = autoInc;
        emit this->autoIncrementChanged();
    }
}

bool SQLitePrimaryKey::isAutoIncremented()
{
    return autoIncrement;
}

void SQLitePrimaryKey::setConflictDetection(ConflictResolution conflict)
{
    if (conflictDetection != conflict) {
        conflictDetection = conflict;
        emit this->conflictDetectionChanged();
    }
}

ConflictResolution SQLitePrimaryKey::getConflictDetection()
{
    return conflictDetection;
}
