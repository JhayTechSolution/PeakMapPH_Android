#include "sqlitetable.h"
#include "sqlitemetadesigner.h"
#include "sqlitekey.h"
#include <QDebug>
#include <cxxabi.h>
#include "sqliteproperty.h"
#include <QUrl>
#include <QQmlEngine>
#include <QQmlContext>
#include <memory.h>
#include <QFileInfo>

SQLiteTable::SQLiteTable(QObject *parent)
    :  QObject{parent},
    withPrimaryKey(false)
{

}


void SQLiteTable::setKeys(QList<SQLiteKey*> keys){
    this->m_keys = keys;
    emit this->keysChanged();
}

QList<SQLiteKey*> SQLiteTable::getKeys(){

    return this->m_keys;
}

void SQLiteTable::componentComplete(){
    this->initTable();
}

void SQLiteTable::initTable(){

    const QMetaObject *mo = this->metaObject();

    if(this->tableName.isEmpty()){
        this->tableName = mo->className();
        this->tableName = this->tableName.split("_QMLTYPE_").at(0);
    }

    for(int i = mo->propertyOffset(); i < mo->propertyCount(); i++){
        QMetaProperty prop = mo->property(i);
        QString name = QString::fromLatin1(prop.name());
        QVariant value = this->property(prop.name());
        if(value.isValid()){
            if(value.canConvert<SQLiteProperty *>()){
                SQLiteProperty* sqlProp = value.value<SQLiteProperty*>();
                if(sqlProp->getColumnName().isEmpty()){
                    sqlProp->setColumnName(name);
                }
            }
        }
    }

}

QString SQLiteTable::getMetaCreate(){
    return  SQLiteMetaDesigner::tableMetaCreate(this);
}
QString SQLiteTable::getInsertMeta(){
    return SQLiteMetaDesigner::insertTableMeta(this);
}

QString SQLiteTable::getUpdateMeta(){
    return SQLiteMetaDesigner::updateTableMeta(this);
}
QString SQLiteTable::getDeleteMeta(){
    return SQLiteMetaDesigner::deteleTableMeta(this);
}
QString SQLiteTable::getSelectMeta(QJsonObject args){
    return SQLiteMetaDesigner::selectTableMeta(this, args);
}
QList<SQLiteProperty*> SQLiteTable::getAllColumns(){
    const QMetaObject *mo = this->metaObject();
    QList<SQLiteProperty*> properties;


    for(int i = mo->propertyOffset(); i < mo->propertyCount(); i++){
        QMetaProperty prop = mo->property(i);
        QString name = QString::fromLatin1(prop.name());
        QVariant value = this->property(prop.name());

        if(value.isValid()){
            if(value.canConvert<SQLiteProperty *>()){
                SQLiteProperty* sqlProp = value.value<SQLiteProperty*>();

                if(sqlProp->isPrimaryKey() && sqlProp->getColumnName() != this->primaryKeyName){
                    if(this->hasPrimaryKey()){

                        qDebug() << "Calling all columns of " << sqlProp->isPrimaryKey() << sqlProp->getColumnName() << this->primaryKeyName;
                        throw std::runtime_error("Cannot create 2 or more sole primary key");
                    } else {
                        this->withPrimaryKey = true;
                        this->primaryKeyName = sqlProp->getColumnName();
                    }
                }
                properties.push_back(sqlProp);
            }
        }
    }
    return properties;
}

void SQLiteTable::setTableName(QString tableName){
    this->tableName = tableName;
    emit this->tableNameChanged();
}

QString SQLiteTable::getTableName(){
    return this->tableName;
}


void SQLiteTable::addKey(SQLiteKey* key){
    this->m_keys.append(key);
    emit this->keysChanged();
}

bool SQLiteTable::hasPrimaryKey(){
    return this->withPrimaryKey;
}

QQmlListProperty<SQLiteKey> SQLiteTable::readKeys(){
    return QQmlListProperty<SQLiteKey>(
        this,
        &this->m_keys

        );
}



void SQLiteTable::appendKey(SQLiteKey *p)
{
    m_keys.append(p);
}

qsizetype SQLiteTable::keyCount() const
{
    return m_keys.count();
}

SQLiteKey *SQLiteTable::key(qsizetype index) const
{
    return m_keys.at(index);
}

void SQLiteTable::clearKeys() {
    m_keys.clear();
}

void SQLiteTable::replaceKey(qsizetype index, SQLiteKey *p)
{
    m_keys[index] = p;
}

void SQLiteTable::removeLastKey()
{
    m_keys.removeLast();
}


void SQLiteTable::appendKey(QQmlListProperty<SQLiteKey> *list, SQLiteKey *p)
{
    reinterpret_cast< SQLiteTable *>(list->data)->appendKey(p);
}

void SQLiteTable::clearKeys(QQmlListProperty<SQLiteKey>* list)
{
    reinterpret_cast< SQLiteTable *>(list->data)->clearKeys();
}

void SQLiteTable::replaceKey(QQmlListProperty<SQLiteKey> *list, qsizetype i, SQLiteKey *p)
{
    reinterpret_cast< SQLiteTable* >(list->data)->replaceKey(i, p);
}

void SQLiteTable::removeLastKey(QQmlListProperty<SQLiteKey> *list)
{
    reinterpret_cast< SQLiteTable* >(list->data)->removeLastKey();
}

SQLiteKey* SQLiteTable::key(QQmlListProperty<SQLiteKey> *list, qsizetype i)
{
    return reinterpret_cast< SQLiteTable* >(list->data)->key(i);
}

qsizetype SQLiteTable::keyCount(QQmlListProperty<SQLiteKey> *list)
{
    return reinterpret_cast< SQLiteTable* >(list->data)->keyCount();
}

QQmlListProperty<SQLiteKey> SQLiteTable::keys(){

    return {this,this,&SQLiteTable::appendKey,
                                       &SQLiteTable::keyCount,
                                                                            &SQLiteTable::key,
                                                                            &SQLiteTable::clearKeys  ,
                                                                            &SQLiteTable::replaceKey,
                                       &SQLiteTable::removeLastKey

    };
}
