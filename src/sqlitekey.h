#ifndef SQLITEKEY_H
#define SQLITEKEY_H

#include <QObject>

class SQLiteProperty;
Q_MOC_INCLUDE("sqliteproperty.h");
namespace SQLite{
enum class ConflictResolution:int;
enum class TriggerConflictResolution:int;
enum class ForeignKeyAction:int;


};
using namespace SQLite;
class SQLiteKey : public QObject
{

    Q_OBJECT

    Q_ENUM(ConflictResolution);
    Q_ENUM(TriggerConflictResolution);
    Q_ENUM(ForeignKeyAction);
    Q_PROPERTY(QList<SQLiteProperty*> columns READ getColumns WRITE setColumns NOTIFY columnsChanged)
public:


    explicit SQLiteKey(QObject *parent = nullptr);

    Q_INVOKABLE void setColumns(QList<SQLiteProperty*> colums);
    QList<SQLiteProperty*> getColumns();
private:
    QList<SQLiteProperty*> columns;
signals:
    void columnsChanged();
};

#endif // SQLITEKEY_H
