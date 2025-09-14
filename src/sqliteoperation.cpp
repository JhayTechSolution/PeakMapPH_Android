#include "sqliteoperation.h"
#include <QJsonObject>
#include <sqlitetable.h>
#include <sqliteproperty.h>
#include <QJsonArray>
#include "sqlitestorage.h"
#include <qjsengine.h>
SQLiteOperation::SQLiteOperation(QObject *parent,SQLiteStorage* db, SQLiteTable* table)
    : QObject{parent}
{
    this->db= db;
    this->table = table;
}

void  SQLiteOperation::insert(QJsonObject arg){
    checkConnection();
    auto keys = arg.keys();
    auto columnKeys = this->table->getAllColumns();
    for(auto k:keys){
        bool found=false;
        for(auto c: columnKeys){
            if(c->getColumnName() == k){
                found = true;
                c->setValue(arg[k].toVariant());
            }
        }
        if(!found){
            auto msg = QString("%1 : Not found in schema table %2").arg(k).arg(this->table->getTableName());
            throw  std::runtime_error(msg.toStdString());

        }

    }

    if(!this->db->writeQuery( this->table->getInsertMeta())){
        throw std::runtime_error("Unable to write insert query");
    }
}

void SQLiteOperation::update(QJsonObject arg){
    checkConnection();
    auto primarykey = this->table->getPrimaryKeyName();
    auto keys = arg.keys();
    auto columnKeys = this->table->getAllColumns();
    bool gotPrimaryKeyId=false;
    for(auto k: keys){
        bool found = false;
        for(auto c:columnKeys){
            if(c->getColumnName() == k){
                if(c->isPrimaryKey()){
                    gotPrimaryKeyId= true;
                }
                found=true;
                c->setValue(arg[k].toVariant());
            }

        }
        if(!found){
            auto msg = QString("%1 : Not found in schema table %2").arg(k).arg(this->table->getTableName());
            throw  std::runtime_error(msg.toStdString());
        }
    }
    if(!gotPrimaryKeyId){
        auto msg = QString("Primary key id must be included for now");
        throw  std::runtime_error(msg.toStdString());
    }
    if(!this->db->writeQuery(this->table->getUpdateMeta())){
        throw std::runtime_error("Unable to update record");
    }

}
void SQLiteOperation::deleteRecord(QJsonObject arg){
    checkConnection();
    //all arg is where
    auto keys = arg.keys();
    auto columnKeys = this->table->getAllColumns();
    for(auto k:keys){
        bool found=false;
        for(auto c: columnKeys){
            if(c->getColumnName() == k){
                found = true;
                c->setValue(arg[k].toVariant());
            }
        }
        if(!found){
            auto msg = QString("%1 : Not found in schema table %2").arg(k).arg(this->table->getTableName());
            throw  std::runtime_error(msg.toStdString());

        }

    }
    if(!this->db->writeQuery(this->table->getDeleteMeta())){
        throw std::runtime_error("Unable to delete record");
    }

}
void SQLiteOperation::checkConnection(){
    if(this->table == nullptr){
        throw std::runtime_error("not connected");
    }
    if(this->db == nullptr){
        throw std::runtime_error("not connected");
    }
}

bool SQLiteOperation::fieldExist(QString field){
    checkConnection();
    auto cols = this->table->getAllColumns();

    for(auto c:cols){
        if(c->getColumnName() == field){
            return true;
        }
    }
    return false;
}

SQLiteOperation* SQLiteOperation::withField(QList<QString> fields){
    checkConnection();
    if(!this->selectArgs.contains("selector")){
        this->selectArgs["selector"] = QJsonArray();
    }
    auto selector = this->selectArgs["selector"].toArray();
    selector.empty();
    for(auto f:fields){
        if(!fieldExist(f)){
            throw std::runtime_error(QString("Field %1, does not exists").arg(f).toStdString());
        }
        selector.append(f);
    }
    this->selectArgs["selector"] = selector;
    return this;
}
SQLiteOperation* SQLiteOperation::filter(QJsonObject args){
    checkConnection();
    if(args.isEmpty()){
        return this;
    }
    if(!this->selectArgs.contains("filters")){
        this->selectArgs["filters"] = QJsonArray();
    }

    auto keys=args.keys();
    for(auto k:keys){
        if(!fieldExist(k)){
            throw std::runtime_error(QString("Field %1, does not exists").arg(k).toStdString());
        }

    }
    auto filters=    this->selectArgs["filters"].toArray();
    filters.append(args);
    this->selectArgs["filters"] =filters;
    return this;
}

SQLiteOperation* SQLiteOperation::filterOr(QJsonObject args){
    checkConnection();
    if(args.isEmpty()){
        return this;
    }

    if(!this->selectArgs.contains("filterOr")){
        this->selectArgs["filterOr"]=QJsonArray();
    }
    auto keys = args.keys();
    for(auto k:keys){
        if(!fieldExist(k)){
            throw std::runtime_error(QString("Field %1, does not exists").arg(k).toStdString());
        }

    }
    auto filters = this->selectArgs["filterOr"].toArray();
    filters.append(args);
    this->selectArgs["filterOr"] = filters;
    return this;
}
SQLiteOperation* SQLiteOperation::limit(int limit){
    checkConnection();
    this->selectArgs["limit"] = limit;
    return this;
}
SQLiteOperation* SQLiteOperation::offset(int offset){
    checkConnection();
    this->selectArgs["offset"] = offset;

    return this;
}
SQLiteOperation* SQLiteOperation::orderBy(QString field){
    checkConnection();
    if(!this->selectArgs.contains("order")){
        this->selectArgs["order"] = QJsonObject();
    }
    if(!fieldExist(field)){
        throw std::runtime_error(QString("Field %1, does not exist").arg(field).toStdString());
    }
    auto order = this->selectArgs["order"].toObject();
    order["by"]=field;
    order["sort"]="ASC";
    this->selectArgs["order"] = order;
    return this;
}

int SQLiteOperation::count(){
    return 0;
}

void SQLiteOperation::getAll(QJSValue callback, bool sortDesc){
    QJsonObject args{
                     {"selector", (this->selectArgs.contains("selector"))? this->selectArgs["selector"].toArray():QJsonArray()}

    };
    if(!args.contains("order")){
        args["order"]=QJsonObject{
            {"by",this->table->getPrimaryKeyName()}
        };
    }
    auto order = args["order"].toObject();
    order["sort"] = (sortDesc)? "DESC":"ASC";
    args["order"] = order;
    auto q = this->db->getQuery(this->table->getSelectMeta(args));
    if(callback.isCallable()){
        QJSValueList rArgs;
        QJSEngine *engine =qjsEngine(this);
        rArgs << engine->toScriptValue(q);
        callback.call(rArgs);
    }
}

void SQLiteOperation::runQuery(QJSValue callback, bool sortDesc){
    checkConnection();
    if(!this->selectArgs.contains("order")){
        this->selectArgs["order"]=QJsonObject{
                                                {"by",this->table->getPrimaryKeyName()}
        };
    }
    auto order = this->selectArgs["order"].toObject();
    order["sort"] = (sortDesc)? "DESC":"ASC";
    this->selectArgs["order"] = order;
    auto q = this->db->getQuery(this->table->getSelectMeta(this->selectArgs));

    if(callback.isCallable()){
        QJSValueList rArgs;
        QJSEngine *engine =qjsEngine(this);
        rArgs << engine->toScriptValue(q);
        callback.call(rArgs);
    }

}



