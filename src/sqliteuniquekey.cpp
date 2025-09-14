#include "sqliteuniquekey.h"
#include "sqliteproperty.h"

using namespace SQLite;
SQLiteUniqueKey::SQLiteUniqueKey(QObject *parent)
    : SQLiteKey(parent),
    conflictDetection(ConflictResolution::ABORT) // global enum value from sqlitekey.h
{
}

void SQLiteUniqueKey::setConflictDetection(ConflictResolution conflict)
{
    if (conflictDetection != conflict) {
        conflictDetection = conflict;
        emit this->conflictDetectionChanged();
    }
}

ConflictResolution SQLiteUniqueKey::getConflictDetection()
{
    return conflictDetection;
}
