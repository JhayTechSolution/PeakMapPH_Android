#ifndef SQLITEFOREIGNKEY_H
#define SQLITEFOREIGNKEY_H

#include <QObject>

#include "sqlitekey.h"
class SQLiteTable;
Q_MOC_INCLUDE("sqlitetable.h")

class SQLiteForeignKey : public SQLiteKey
{
    Q_OBJECT
    Q_PROPERTY(SQLiteTable* referenceTable READ getReferenceTable WRITE setReferenceTable NOTIFY referenceTableChanged());
    Q_PROPERTY(QList<SQLiteProperty*> referenceColumns READ getReferenceColumn WRITE setReferenceColumns NOTIFY referenceColumnsChanged)
    Q_PROPERTY(TriggerConflictResolution conflictDetection READ getConflictDetection WRITE setConflictDetection NOTIFY conflictDetectionChanged)
    Q_PROPERTY(ForeignKeyAction conflictAction READ getConflictAction WRITE setConflictAction NOTIFY conflictActionChanged)
public:
    explicit SQLiteForeignKey(QObject *parent = nullptr);
    Q_INVOKABLE void setReferenceColumns(QList<SQLiteProperty *> columns);
    Q_INVOKABLE void setReferenceTable(SQLiteTable* referenceTable);
    Q_INVOKABLE void setConflictDetection(TriggerConflictResolution conflictDetection);
    Q_INVOKABLE void setConflictAction(ForeignKeyAction conflictAction);

    QList<SQLiteProperty*> getReferenceColumn();
    SQLiteTable* getReferenceTable();
    TriggerConflictResolution getConflictDetection();
    ForeignKeyAction getConflictAction();

private:
    SQLiteTable* referenceTable;
    QList<SQLiteProperty *> referenceColumns;
    TriggerConflictResolution conflictDetection;
    ForeignKeyAction conflictAction;
signals:
    void referenceTableChanged();
    void referenceColumnsChanged();
    void conflictDetectionChanged();
    void conflictActionChanged();
};

#endif // SQLITEFOREIGNKEY_H
