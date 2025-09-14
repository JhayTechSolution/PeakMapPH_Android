#include "sqlitekey.h"
#include "sqliteproperty.h"
SQLiteKey::SQLiteKey(QObject *parent)
    : QObject{parent}
{}

void SQLiteKey::setColumns(QList<SQLiteProperty*> columns){
    this->columns = columns;
    emit this->columnsChanged();
}

QList<SQLiteProperty*> SQLiteKey::getColumns(){
    return this->columns;
}
