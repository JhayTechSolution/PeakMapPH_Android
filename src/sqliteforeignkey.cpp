#include "sqliteforeignkey.h"
#include "sqlitetable.h"
#include "sqliteproperty.h"
#include "sqlitedatatype.h"
using namespace SQLite;
SQLiteForeignKey::SQLiteForeignKey(QObject *parent)
    : SQLiteKey(parent),
    referenceTable(nullptr),
    conflictDetection(TriggerConflictResolution::NORESO),  // default value from TriggerConflictResolution
    conflictAction(ForeignKeyAction:: NOACTION)    // default value from ForeignKeyAction
{
}

void SQLiteForeignKey::setReferenceColumns(QList<SQLiteProperty *> columns)
{
    if (referenceColumns != columns) {
        referenceColumns = columns;
        emit this->referenceColumnsChanged();
    }
}

void SQLiteForeignKey::setReferenceTable(SQLiteTable* table)
{
    if (referenceTable != table) {
        referenceTable = table;
        emit this->referenceTableChanged();
    }
}

void SQLiteForeignKey::setConflictDetection(TriggerConflictResolution conflict)
{
    if (conflictDetection != conflict) {
        conflictDetection = conflict;
        emit this->conflictDetectionChanged();
    }
}

void SQLiteForeignKey::setConflictAction(ForeignKeyAction action)
{
    if (conflictAction != action) {
        conflictAction = action;
        emit this->conflictActionChanged();
    }
}

QList<SQLiteProperty*> SQLiteForeignKey::getReferenceColumn()
{
    return referenceColumns;
}

SQLiteTable* SQLiteForeignKey::getReferenceTable()
{
    return referenceTable;
}

TriggerConflictResolution SQLiteForeignKey::getConflictDetection()
{
    return conflictDetection;
}

ForeignKeyAction SQLiteForeignKey::getConflictAction()
{
    return conflictAction;
}

