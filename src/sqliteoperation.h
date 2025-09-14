#ifndef SQLITEOPERATION_H
#define SQLITEOPERATION_H

#include <QObject>
#include <QJsonObject>
#include <QJSValue>
class SQLiteTable;
class SQLiteStorage;
class SQLiteOperation : public QObject
{
    Q_OBJECT
public:
    explicit SQLiteOperation(QObject *parent = nullptr, SQLiteStorage* db=nullptr, SQLiteTable* table=nullptr);
    Q_INVOKABLE void insert(QJsonObject arg);
    Q_INVOKABLE void update(QJsonObject arg);
    Q_INVOKABLE void deleteRecord(QJsonObject arg);
    Q_INVOKABLE SQLiteOperation* withField(QList<QString> fields);
    Q_INVOKABLE SQLiteOperation* filter(QJsonObject arg);
    Q_INVOKABLE SQLiteOperation* filterOr(QJsonObject arg);
    Q_INVOKABLE SQLiteOperation* limit(int limit);
    Q_INVOKABLE SQLiteOperation* offset(int offset);
    Q_INVOKABLE SQLiteOperation* orderBy(QString order);
    Q_INVOKABLE void getAll(QJSValue callback, bool sortDesc=false); //get all only works with withfield,other not
    Q_INVOKABLE int count();
    Q_INVOKABLE void runQuery(QJSValue callback, bool sortDesc=false); // works with withField().filter().filterOr().limit().offset()
    bool fieldExist(QString field);
private:
    SQLiteTable* table;
    SQLiteStorage* db;
    QJsonObject selectArgs;
    void checkConnection();

signals:
};

#endif // SQLITEOPERATION_H
