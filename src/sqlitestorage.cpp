#include "sqlitestorage.h"
#include <QSqlRecord>
#include <sqlitetable.h>
#include "sqliteoperation.h"
QString SQLiteStorage::appDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);

SQLiteStorage::SQLiteStorage(QObject *parent)
    : QObject(parent)
{
}

SQLiteStorage::~SQLiteStorage() {
    if (db.isOpen()) db.close();
}

void SQLiteStorage::setDbName(const QString &name) {
    dbName = name;
    emit dbNameChanged();
}

QString SQLiteStorage::getDbName() const {
    return dbName;
}

void SQLiteStorage::open() {
    if (dbName.isEmpty()) {
        throw std::runtime_error("No DB selected/created");
    }

    db = QSqlDatabase::addDatabase("QSQLITE"); // Correct driver
    QString fullPath = appDir + "/" + dbName;
    db.setDatabaseName(fullPath);

    if (!db.open()) {
        throw std::runtime_error(("Failed to open DB: " + db.lastError().text()).toStdString());
    }

    emit dbOpen();
    init();
}

void SQLiteStorage::init(){
    if(m_tables.length() == 0) return ;
    for(auto table:m_tables){
        QString metaCreate = table->getMetaCreate();
        qDebug() << metaCreate;
        writeQuery(metaCreate);
    }
}



void SQLiteStorage::close() {
    if (db.isOpen()) {
        db.close();
        emit dbClosed();
    }
}

QJsonArray SQLiteStorage::queryToJson(QSqlQuery &query) {
    QJsonArray jsonArray;

    while (query.next()) {
        QSqlRecord record = query.record();
        QJsonObject obj;

        for (int i = 0; i < record.count(); ++i) {
            QString key = record.fieldName(i);
            QVariant value = record.value(i);
            obj.insert(key, QJsonValue::fromVariant(value));
        }

        jsonArray.append(obj);
    }

    return jsonArray;
}

QJsonArray SQLiteStorage::getQuery(const QString &queryStr) {
    if (!db.isOpen()) {
        throw std::runtime_error("DB is not open");
    }

    QSqlQuery q(db);
    if (!q.exec(queryStr)) {
        qDebug() << "Query error:" << q.lastError().text();
        return {};
    }

    return queryToJson(q);
}

bool SQLiteStorage::writeQuery(const QString &queryStr) {
    if (!db.isOpen()) {
        throw std::runtime_error("DB is not open");
    }

    QSqlQuery q(db);
    if (!q.exec(queryStr)) {
        qDebug() << "Write query error:" << q.lastError().text();
        return false;
    }

    return true;
}

bool SQLiteStorage::writeQueryWithParams(const QString &queryStr, const QList<QJsonValue> &args) {
    if (!db.isOpen()) {
        throw std::runtime_error("DB is not open");
    }

    QSqlQuery q(db);
    q.prepare(queryStr);

    for (const QJsonValue &js : args) {
        if (js.isObject()) {
            QJsonObject obj = js.toObject();
            for (auto it = obj.begin(); it != obj.end(); ++it) {
                QVariant value;

                if (it.value().isObject() || it.value().isArray()) {
                    value = QString(QJsonDocument(it.value().toObject()).toJson(QJsonDocument::Compact));
                } else {
                    value = it.value().toVariant();
                }

                q.bindValue(":" + it.key(), value);
            }
        } else {
            q.addBindValue(js.toVariant());
        }
    }

    if (!q.exec()) {
        qDebug() << "Write query with params error:" << q.lastError().text();
        return false;
    }

    return true;
}





//tables
void SQLiteStorage::appendTable(SQLiteTable *p)
{
    m_tables.append(p);
}

qsizetype SQLiteStorage::tableCount() const
{
    return m_tables.count();
}

SQLiteTable *SQLiteStorage::table(qsizetype index) const
{
    return m_tables.at(index);
}

void SQLiteStorage::clearTable() {
    m_tables.clear();
}

void SQLiteStorage::replaceTable(qsizetype index, SQLiteTable *p)
{
    m_tables[index] = p;
}

void SQLiteStorage::removeLastTable()
{
    m_tables.removeLast();
}


void SQLiteStorage::appendTable(QQmlListProperty<SQLiteTable> *list, SQLiteTable *p)
{
    reinterpret_cast< SQLiteStorage *>(list->data)->appendTable(p);
}

void SQLiteStorage::clearTable(QQmlListProperty<SQLiteTable>* list)
{
    reinterpret_cast< SQLiteStorage *>(list->data)->clearTable();
}

void SQLiteStorage::replaceTable(QQmlListProperty<SQLiteTable> *list, qsizetype i, SQLiteTable *p)
{
    reinterpret_cast< SQLiteStorage* >(list->data)->replaceTable(i, p);
}

void SQLiteStorage::removeLastTable(QQmlListProperty<SQLiteTable> *list)
{
    reinterpret_cast< SQLiteStorage* >(list->data)->removeLastTable();
}

SQLiteTable* SQLiteStorage::table(QQmlListProperty<SQLiteTable> *list, qsizetype i)
{
    return reinterpret_cast< SQLiteStorage* >(list->data)->table(i);
}

qsizetype SQLiteStorage::tableCount(QQmlListProperty<SQLiteTable> *list)
{
    return reinterpret_cast< SQLiteStorage* >(list->data)->tableCount();
}

QQmlListProperty<SQLiteTable> SQLiteStorage::tables(){

    return {this, this,&SQLiteStorage::appendTable,
        &SQLiteStorage::tableCount,
        &SQLiteStorage::table,
        &SQLiteStorage::clearTable  ,
        &SQLiteStorage::replaceTable,
        &SQLiteStorage::removeLastTable

    };
}

SQLiteOperation* SQLiteStorage::useTable(QString tableName){
    for(auto tbl: m_tables){
        if(tbl->getTableName() == tableName){
            return new SQLiteOperation(this, this, tbl);
        }
    }
    return nullptr;
}


