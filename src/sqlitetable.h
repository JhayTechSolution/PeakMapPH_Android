#ifndef SQLITETABLE_H
#define SQLITETABLE_H

#include <QObject>
#include <QQmlParserStatus>
Q_MOC_INCLUDE("sqlitekey.h")
Q_MOC_INCLUDE("sqliteproperty.h")
#include <QQmlListProperty>
#include <QJsonObject>
class SQLiteKey;
class SQLiteProperty;class SQLiteTable : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

    QML_LIST_PROPERTY_ASSIGN_BEHAVIOR_APPEND
    Q_PROPERTY(QQmlListProperty<SQLiteKey> keys READ keys )
    Q_PROPERTY(QString tableName READ getTableName WRITE setTableName NOTIFY tableNameChanged)
public:

    using QObject::QObject;
    explicit SQLiteTable(QObject *parent = nullptr);

    QQmlListProperty<SQLiteKey> readKeys();  // <-- for QML
    QList<SQLiteKey*> getKeys();             // <-- for C++

    Q_INVOKABLE void initTable();
    Q_INVOKABLE void setKeys(QList<SQLiteKey*> keys);
    Q_INVOKABLE void addKey(SQLiteKey* key);
    Q_INVOKABLE void setTableName(QString tableName);

    QString getTableName();
    QList<SQLiteProperty*> getAllColumns();

    void componentComplete() override;
    void classBegin() override {}

    bool hasPrimaryKey();
    // SQLiteTable.cpp

    void appendKey(SQLiteKey * key);
    qsizetype keyCount() const;
    SQLiteKey* key(qsizetype index) const;
    void clearKeys();
    void replaceKey(qsizetype index,SQLiteKey *key);
    void removeLastKey();

    QQmlListProperty<SQLiteKey> keys();


    static void appendKey(QQmlListProperty<SQLiteKey> *keys, SQLiteKey *key);
    static void clearKeys(QQmlListProperty<SQLiteKey> *keys);
    static void replaceKey(QQmlListProperty<SQLiteKey> *keys, qsizetype i, SQLiteKey* key);
    static void removeLastKey(QQmlListProperty<SQLiteKey> *keys);
    static SQLiteKey* key(QQmlListProperty<SQLiteKey> *keys, qsizetype i);
    static qsizetype keyCount(QQmlListProperty<SQLiteKey> *keys);
    QString getMetaCreate();

    QString getInsertMeta();
    QString getUpdateMeta();
    QString getDeleteMeta();
    QString getSelectMeta(QJsonObject args);
    QString getPrimaryKeyName(){ return this->primaryKeyName;}
signals:
    void keysChanged();
    void tableNameChanged();

private:

    QList<SQLiteKey*> m_keys;  // internal storage
    QString tableName;
    bool withPrimaryKey = false;
    QString primaryKeyName;
};

#endif // SQLITETABLE_H
