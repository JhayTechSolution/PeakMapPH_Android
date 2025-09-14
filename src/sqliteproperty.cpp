#include "sqliteproperty.h"

SQLiteProperty::SQLiteProperty(QObject *parent)
    : QObject(parent),
    nullable(true),
    dataType(SQLiteDataType::TEXT) ,
    conflictDetection(ConflictResolution::ABORT),
    markAsPrimaryKey(false),
    autoIncrement(false)
{
}

void SQLiteProperty::setNullable(bool nullable)
{
    if (this->nullable != nullable) {
        this->nullable = nullable;
        emit nullableChanged();
    }
}

void SQLiteProperty::setColumnName(QString columnName)
{
    if (this->columnName != columnName) {
        this->columnName = std::move(columnName);
        emit columnNameChanged();
    }
}

void SQLiteProperty::setDataType(SQLiteDataType dataType)
{
    qDebug() << dataType;
    if (this->dataType != dataType) {
        this->dataType = dataType;
        emit dataTypeChanged();
    }
}

void SQLiteProperty::setValue(QVariant value)
{
    if (this->value != value) {
        this->value = std::move(value);
        emit valueChanged();
    }
}

void SQLiteProperty::setDefaultValue(QVariant defaultValue)
{
    if (this->defaultValue != defaultValue) {
        this->defaultValue = std::move(defaultValue);
        emit defaultValueChanged();
    }
}

bool SQLiteProperty::isNullable()
{
    return nullable;
}

QString SQLiteProperty::getColumnName()
{
    return columnName;
}

SQLiteDataType SQLiteProperty::getDataType()
{
    return dataType;
}

QVariant SQLiteProperty::getValue()
{
    return value;
}

QVariant SQLiteProperty::getDefaultValue()
{
    return defaultValue;
}

void SQLiteProperty::setConflictDetection(ConflictResolution conflictDetection){
    if(this->conflictDetection != conflictDetection){
        this->conflictDetection = conflictDetection;
        emit this->conflictDetectionChanged();
    }

}
ConflictResolution SQLiteProperty::getConflictDetection(){
    return this->conflictDetection;
}

void SQLiteProperty::setMarkAsPrimaryKey(bool isPrimaryKey){
    if(this->markAsPrimaryKey != isPrimaryKey){
        this->markAsPrimaryKey = isPrimaryKey;
        this->setNullable(false);
        emit this->markAsPrimaryKeyChanged();
    }
}

bool SQLiteProperty::isPrimaryKey(){
    return this->markAsPrimaryKey;
}

void SQLiteProperty::setAutoIncrement(bool autoIncrement){
    if(this->autoIncrement != autoIncrement){
        this->autoIncrement = autoIncrement;
        emit this->autoIncrementChanged();
    }
}

bool SQLiteProperty::isAutoIncremented(){
    return this->autoIncrement;
}
