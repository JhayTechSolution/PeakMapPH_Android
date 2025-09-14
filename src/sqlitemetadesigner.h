#ifndef SQLITEMETADESIGNER_H
#define SQLITEMETADESIGNER_H

#include <QObject>

Q_MOC_INCLUDE("sqliteproperty.h")
Q_MOC_INCLUDE("sqlitetable.h");
#include <QJsonObject>
class SQLiteTable;
class SQLiteProperty;
class SQLiteMetaDesigner : public QObject
{
    Q_OBJECT
public:
    explicit SQLiteMetaDesigner(QObject *parent = nullptr);
    static QString tableMetaCreate(SQLiteTable* table);
    static QString columnsMetaCreate(SQLiteTable* table, QList<SQLiteProperty*> props);
    static QString insertTableMeta(SQLiteTable* table);
    static QString updateTableMeta(SQLiteTable *table);
    static QString deteleTableMeta(SQLiteTable *table);
    static QString selectTableMeta(SQLiteTable *table, QJsonObject args);
private:
    static QString columnMetaCreate(SQLiteTable* table,SQLiteProperty* prop);
signals:
};

#endif // SQLITEMETADESIGNER_H
