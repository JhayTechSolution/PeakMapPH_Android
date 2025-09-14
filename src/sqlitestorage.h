#ifndef SQLITESTORAGE_H
#define SQLITESTORAGE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonDocument>
#include <QStandardPaths>
#include <QQmlListProperty>
#include <QDebug>
#include <QQmlParserStatus>
Q_MOC_INCLUDE("sqlitetable.h")
Q_MOC_INCLUDE("sqliteproperty.h");
class SQLiteTable;
class SQLiteProperty;
class SQLiteOperation;
class SQLiteStorage : public QObject,public QQmlParserStatus

{

    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

    QML_LIST_PROPERTY_ASSIGN_BEHAVIOR_APPEND
    Q_PROPERTY(QQmlListProperty<SQLiteTable> tables READ tables)
    Q_PROPERTY(QString db READ getDbName WRITE setDbName NOTIFY dbNameChanged)
public:
    explicit SQLiteStorage(QObject *parent = nullptr);
    ~SQLiteStorage();

    Q_INVOKABLE  void setDbName(const QString &dbName);
    QString getDbName() const;

    Q_INVOKABLE void open();
    Q_INVOKABLE void close();

    QJsonArray getQuery(const QString &queryStr);
    bool writeQuery(const QString &queryStr);
    bool writeQueryWithParams(const QString &queryStr, const QList<QJsonValue> &args);

    QQmlListProperty<SQLiteTable> tables();
    void appendTable(SQLiteTable *table);
    void clearTable();
    void replaceTable(qsizetype i, SQLiteTable* table);
    void removeLastTable();
    SQLiteTable* table(qsizetype i) const;
    qsizetype tableCount() const;
    void classBegin() override{}
    void componentComplete() override{}
    Q_INVOKABLE SQLiteOperation* useTable(QString tableName);
    void init();
signals:
    void dbOpen();
    void dbClosed();
    void dbNameChanged();


private:

    QString dbName;
    QSqlDatabase db;
    static QString appDir;
    QList<SQLiteTable*> m_tables;

    QJsonArray queryToJson(QSqlQuery &query);


    static void appendTable(QQmlListProperty<SQLiteTable> *tables, SQLiteTable *table);
    static void clearTable(QQmlListProperty<SQLiteTable> *tables);
    static void replaceTable(QQmlListProperty<SQLiteTable> *tables, qsizetype i, SQLiteTable* table);
    static void removeLastTable(QQmlListProperty<SQLiteTable> *tables);
    static SQLiteTable* table(QQmlListProperty<SQLiteTable> *tables, qsizetype i);
    static qsizetype tableCount(QQmlListProperty<SQLiteTable> *tables);

};

#endif // SQLITESTORAGE_H
