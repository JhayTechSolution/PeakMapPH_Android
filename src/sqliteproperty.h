#ifndef SQLITEPROPERTY_H
#define SQLITEPROPERTY_H

#include <QObject>
#include "sqlitedatatype.h"
#include <QVariant>
using namespace SQLite;
#include "sqlitekey.h"

class SQLiteProperty : public QObject
{

    Q_ENUM(SQLiteDataType)

    Q_OBJECT
    Q_PROPERTY(bool nullable READ isNullable WRITE setNullable NOTIFY nullableChanged)
    Q_PROPERTY(QString columnName READ getColumnName WRITE setColumnName NOTIFY columnNameChanged)
    Q_PROPERTY(SQLiteDataType dataType READ getDataType WRITE setDataType NOTIFY dataTypeChanged)
    Q_PROPERTY(QVariant value READ getValue WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(QVariant defaultValue READ getDefaultValue WRITE setDefaultValue NOTIFY defaultValueChanged)
    Q_PROPERTY(ConflictResolution conflictDetection READ getConflictDetection WRITE setConflictDetection NOTIFY conflictDetectionChanged)
    Q_PROPERTY(bool isPrimaryKey READ isPrimaryKey WRITE setMarkAsPrimaryKey NOTIFY markAsPrimaryKeyChanged)
    Q_PROPERTY(bool isAutoIncrement READ isAutoIncremented WRITE setAutoIncrement NOTIFY autoIncrementChanged)
public:

    explicit SQLiteProperty(QObject *parent = nullptr);
    Q_INVOKABLE void setNullable(bool nullable);
    Q_INVOKABLE void setColumnName(QString columnName);
    Q_INVOKABLE void setDataType(SQLiteDataType dataType);
    Q_INVOKABLE void setValue(QVariant value);
    Q_INVOKABLE void setDefaultValue(QVariant defaultValue);
    bool isNullable();
    QString getColumnName();
    SQLiteDataType getDataType();
    QVariant getValue();
    QVariant getDefaultValue();
    Q_INVOKABLE void setConflictDetection(ConflictResolution conflictDetection);
    ConflictResolution getConflictDetection();
    Q_INVOKABLE void setMarkAsPrimaryKey(bool isPrimaryKey);
    bool isPrimaryKey();
    Q_INVOKABLE void setAutoIncrement(bool isAutoIncrement);
    bool isAutoIncremented();



private:
    bool nullable;
    QString columnName;
    SQLiteDataType dataType;
    QVariant value;
    QVariant defaultValue;
    bool markAsPrimaryKey;
    bool autoIncrement;
    ConflictResolution conflictDetection;
signals:
    void nullableChanged();
    void columnNameChanged();
    void dataTypeChanged();
    void valueChanged();
    void conflictDetectionChanged();
    void defaultValueChanged();
    void autoIncrementChanged();
    void markAsPrimaryKeyChanged();

};

#endif // SQLITEPROPERTY_H
