#include "sqlitemetadesigner.h"
#include "sqlitetable.h"
#include "sqliteproperty.h"
#include "sqlitekey.h"
#include "sqliteprimarykey.h"
#include "sqliteforeignkey.h"
#include "sqliteuniquekey.h"
#include <QJsonArray>
QString dataTypeConvert(SQLiteDataType dataType){
    switch(dataType){
    case SQLiteDataType::INTEGER:
        return "INTEGER";
    case SQLiteDataType::BLOB:
        return "BLOB";
    case SQLiteDataType::REAL:
        return "REAL";
    default:
        return "TEXT";
    }
}

QString createDefaultValue(QString createColumn, QVariant defaultValue, SQLiteDataType dataType){
    switch(dataType){
    case SQLiteDataType::INTEGER:
        if(!defaultValue.isNull()){
            if(defaultValue.canConvert<int>()){
                return createColumn + (QString(" DEFAULT %1").arg(defaultValue.value<int>()));
            }

        }
        break;
    case SQLiteDataType::BLOB:
        if(!defaultValue.isNull()){
            if(defaultValue.canConvert<QByteArray>()){

                return createColumn + (QString(" DEFAULT %1").arg(defaultValue.value<QByteArray>()));
            }
        }
        break;
    case SQLiteDataType::REAL:
        if(!defaultValue.isNull()){
            if(defaultValue.canConvert<float>()){

                return createColumn + (QString(" DEFAULT %1").arg(defaultValue.value<float>()));
            }
        }
        break;
    default:
        if(!defaultValue.isNull()){
            if(defaultValue.canConvert<QString>()){

                return createColumn + (QString(" DEFAULT %1").arg(defaultValue.value<QString>()));
            }
        }
        break;
    }
    return "";
}
QString addAutoConflictDetection(ConflictResolution resolution){
    switch(resolution){
    case SQLite::ConflictResolution::FAIL:
        return " ON CONFLICT FAIL";
    case SQLite::ConflictResolution::IGNORE:
        return " ON CONFLICT IGNORE";
    case SQLite::ConflictResolution::REPLACE:
        return " ON CONFLICT REPLACE";
    case SQLite::ConflictResolution::ROLLBACK:
        return " ON CONFLICT ROLLBACK";
    default:
        return " ON CONFLICT ABORT";
    }
}

QString addTriggerDetection(TriggerConflictResolution conflictDetection){
    switch(conflictDetection){
    case SQLite::TriggerConflictResolution::UPDATE:
        return " ON UPDATE";
    case SQLite::TriggerConflictResolution::DELETE:
        return " ON DELETE";
    default:
        return "";
    }
}

QString addForeignKeyAction(ForeignKeyAction action){
    switch(action){
    case SQLite::ForeignKeyAction::NOACTION:
        return " NO ACTION";
    case SQLite::ForeignKeyAction::CASCADE:
        return " CASCADE";
    case SQLite::ForeignKeyAction::RESTRICT:
        return " RESTRICT";
    case SQLite::ForeignKeyAction::SETDEFAULT:
        return " SET DEFAULT";
    case SQLite::ForeignKeyAction::SETNULL:
        return " SET NULL";
    default:
        return "";
    }
}


int getCountPrimaryKey(QList<SQLiteProperty*> props){
    int count=0;
    for(auto prop:props){
        if(prop->isPrimaryKey()){
            count++;
        }
    }
    return count;
}



SQLiteMetaDesigner::SQLiteMetaDesigner(QObject *parent)
    : QObject{parent}
{}


QString SQLiteMetaDesigner::tableMetaCreate(SQLiteTable* table){

    QString tbl = "CREATE TABLE IF NOT EXISTS %1 (%2) ";
        qDebug() << table->getTableName();


    auto    allColumns = table->getAllColumns();
        qDebug() << "all column";
    if(getCountPrimaryKey(allColumns) > 1){
        throw new std::runtime_error("PRIMARY KEY must not be more than 1 column or make it composite if need more column");
    }

    auto columnCreate  =columnsMetaCreate(table, allColumns);

    auto keys = table->getKeys();
    if(keys.length() > 0){
        QList<QString> constraints;
        for(auto key:keys){
            if(auto fk = qobject_cast<SQLiteForeignKey*>(key)){
                QString fkConstraints="FOREIGN KEY (%1) REFERENCES %2(%3)";
                auto fkColumns = fk->getColumns();
                QList<QString> fkCol;
                for(auto fkc:fkColumns){
                    fkCol.append(fkc->getColumnName());
                }
                auto fkReferences = fk->getReferenceColumn();
                QList<QString> fkRef;
                for(auto fkr: fkReferences){
                    fkRef.append(fkr->getColumnName());
                }
                fkConstraints = fkConstraints.arg(fkCol.join(",")).arg(fk->getReferenceTable()->getTableName()).arg(fkRef.join(","));
                if(fk->getConflictDetection() != TriggerConflictResolution::NORESO){
                    fkConstraints = fkConstraints+addTriggerDetection(fk->getConflictDetection())+addForeignKeyAction(fk->getConflictAction());
                }
                constraints.push_back(fkConstraints);

            }else if(auto uk= qobject_cast<SQLiteUniqueKey*>(key)){
                QString ukConstraints = "UNIQUE KEY (%1)";
                auto ukColums = uk->getColumns();
                QList<QString> ukCol;
                for(auto ukc: ukColums){
                    ukCol.append(ukc->getColumnName());
                }
                ukConstraints = ukConstraints.arg(ukCol.join(","));
                auto uconflict = uk->getConflictDetection();
                if(uconflict != ConflictResolution::ABORT){
                    ukConstraints = ukConstraints +addAutoConflictDetection(uconflict);
                }
                constraints.push_back(ukConstraints);
            }else if(auto pk = qobject_cast<SQLitePrimaryKey*>(key)){
                if(table->hasPrimaryKey()){
                    throw new std::runtime_error("This table have already primary key, cannot create a composite or another primary key");
                }
                QString pkConstraints = "PRIMARY KEY (%1)";
                auto pkColumns = pk->getColumns();
                QList<QString> pkCol;
                for(auto pkc:pkColumns){
                    pkCol.append(pkc->getColumnName());
                }
                pkConstraints = pkConstraints.arg(pkCol.join(","));
                auto pconflict = pk->getConflictDetection();
                if(pconflict != ConflictResolution::ABORT){
                    pkConstraints = pkConstraints + addAutoConflictDetection(pconflict);
                }
                constraints.push_back(pkConstraints);


            }else{
                throw new std::runtime_error("COnstraints not found");
            }
        }
        columnCreate = columnCreate + ", " +constraints.join(",");
    }


    tbl = tbl.arg(table->getTableName()).arg(columnCreate);
    return tbl+";";
}

QString SQLiteMetaDesigner::columnsMetaCreate(SQLiteTable* table , QList<SQLiteProperty*> props){
    QList<QString> createColumns;
    for(auto prop:props){
        auto c=columnMetaCreate(table,prop);
        createColumns.append(c);
    }
    return createColumns.join(",");
}

QString SQLiteMetaDesigner::columnMetaCreate(SQLiteTable* table , SQLiteProperty* prop){
    QString createColumn = "%1 %2";
    QString columnName = prop->getColumnName();
    createColumn = createColumn.arg(prop->getColumnName()).arg(dataTypeConvert(prop->getDataType()));
    if(prop->isPrimaryKey()){
        createColumn =createColumn+ " PRIMARY KEY";
        if(prop->isNullable()){
            throw new std::runtime_error("setting it as primary key should not be nullable");
        }
    }
    if(prop->isAutoIncremented()){
        createColumn=createColumn+ " AUTOINCREMENT";
    }


    if(!prop->isNullable() && !prop->isPrimaryKey()){
        createColumn= createColumn +" NOT NULL";
    }
    if(!prop->isPrimaryKey() && !prop->isNullable()){
        createColumn = createColumn+addAutoConflictDetection(prop->getConflictDetection());
    }
    if(!prop->getDefaultValue().isNull()){
        createColumn =createDefaultValue(createColumn , prop->getDefaultValue() , prop->getDataType());


    }





    return createColumn;
}

QString matchValueDataType(QVariant value, SQLiteDataType dataType){
    switch(dataType){
    case SQLite::SQLiteDataType::BLOB:
        return QString("'%1'").arg(value.toString()); //expecting hex base64
    case SQLite::SQLiteDataType::INTEGER:
        return QString::number(value.toInt());
    case SQLite::SQLiteDataType::REAL:
        return QString::number(value.toFloat());
    default:
        return QString("'%1'").arg(value.toString());
    }
}
QString SQLiteMetaDesigner::insertTableMeta(SQLiteTable* table){
    QString metaInsert="INSERT INTO %1 (%2) VALUES (%3)";
    QString tableName = table->getTableName();
    QList<QString> fields;
    QList<QString> values;
    auto columns = table->getAllColumns();
    //search columns with value
    for(auto c : columns){
        if(!c->getValue().isNull()){
            fields.push_back(c->getColumnName());
            values.push_back(matchValueDataType(c->getValue(),c->getDataType()));
            c->setValue(QVariant::fromValue(nullptr)); //delete values;
        }
    }
    return metaInsert.arg(tableName).arg(fields.join(',')).arg(values.join(','));
}

QString SQLiteMetaDesigner::deteleTableMeta(SQLiteTable* table){
    QString metaDelete = "DELETE FROM %1 WHERE %2";
    QList<QString> fieldValue;
    auto columns = table->getAllColumns();
    for(auto c: columns){
        if(!c->getValue().isNull()){

            fieldValue.push_back(QString("%1=%2").arg(c->getColumnName()).arg(matchValueDataType(c->getValue(),c->getDataType())) );


            c->setValue(QVariant::fromValue(nullptr));
        }
    }
    return metaDelete.arg(table->getTableName()) .arg(fieldValue.join(" AND "));
}


QString SQLiteMetaDesigner::updateTableMeta(SQLiteTable *table){
    QString metaUpdate = "UPDATE %1 SET %2 WHERE %3";
    auto primaryKeyField  = table->getPrimaryKeyName();
    QList<QString> fieldValue;
    QString conditionWhere;
    auto columns = table->getAllColumns();
    for(auto c: columns){
        if(!c->getValue().isNull()){
            if(c->getColumnName() == primaryKeyField){
                conditionWhere = primaryKeyField+"="+matchValueDataType(c->getValue(), c->getDataType());

            }else{
                fieldValue.push_back(QString("%1=%2").arg(c->getColumnName()).arg(matchValueDataType(c->getValue(),c->getDataType())) );

            }
            c->setValue(QVariant::fromValue(nullptr));
        }
    }

    return metaUpdate.arg(table->getTableName()). arg(fieldValue.join(",")).arg(conditionWhere);

}


QString SQLiteMetaDesigner::selectTableMeta(SQLiteTable *table, QJsonObject selectArgs){
    QString commonSelect="SELECT %1 FROM %2";
    if(!selectArgs.contains("order")){
        selectArgs["order"]= QJsonObject{
                            {"by",table->getPrimaryKeyName()},
                            {"sort","ASC"}
        };
    }
    auto order=selectArgs["order"].toObject();
    auto jsonArrayToStringList = [](const QJsonArray &arr) {
        QList<QString> out;
        out.reserve(arr.size());
        for (const auto &v : arr)
            out.append(v.toString());
        return out;
    };

    QList<QString> withFields{ "*" };

    if (selectArgs.contains("selector")) {
        withFields = jsonArrayToStringList(selectArgs["selector"].toArray());
        if(withFields.length() == 0){
            withFields.append("*");
        }
    }
    qDebug() << selectArgs;
    commonSelect = commonSelect.arg(withFields.join(",")).arg(table->getTableName());
    auto columns = table->getAllColumns();
    if(selectArgs.contains("filters")){
        QString where = " WHERE %1";

        QList<QString> whereClauseString;
        auto filters = selectArgs["filters"].toArray();
        for(auto f:filters){
            auto filter = f.toObject();
            auto filterKeys = filter.keys();

            for(auto fk:filterKeys){
                for(auto c: columns){
                    if(c->getColumnName() == fk){
                        whereClauseString.append(QString("%1=%2").arg(fk).arg(matchValueDataType(filter[fk].toVariant(),c->getDataType())));
                    }
                }
            }
        }
        QString whereComplete=QString("(%1)").arg(whereClauseString.join(" AND "));
        if(selectArgs.contains("filterOr")){
            QList<QString> orClause;
            auto filterOr = selectArgs["filterOr"].toArray();
            for(auto f:filterOr){
                auto filter = f.toObject();
                auto filterKeys = filter.keys();
                for(auto fk: filterKeys){
                    for(auto c: columns){
                        if(c->getColumnName() == fk){
                            orClause.append(QString("%1=%2").arg(fk).arg(matchValueDataType(filter[fk].toVariant(), c->getDataType())));
                        }
                    }
                }
            }

            whereComplete = whereComplete +" OR "+ QString("(%1)").arg(orClause.join(" AND "));
        }
        commonSelect = commonSelect +" "+where.arg(whereComplete);
    }
    QString commonOrder = QString(" ORDER BY %1 %2").arg(selectArgs["order"].toObject()["by"].toString()).arg(selectArgs["order"].toObject()["sort"].toString());
    if(selectArgs.contains("limit")){
        commonOrder = commonOrder + QString(" LIMIT %1").arg(selectArgs["limit"].toInt());
        if(selectArgs.contains("offset")){
            commonOrder = commonOrder+QString(" OFFSET %1").arg(selectArgs["offset"].toInt());
        }

    }

    return commonSelect + commonOrder;



}
