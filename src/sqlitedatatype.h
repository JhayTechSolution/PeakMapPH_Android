#ifndef SQLITEDATATYPE_H
#define SQLITEDATATYPE_H

#include <QObject>


namespace SQLite {
    Q_NAMESPACE
    enum class SQLiteDataType{
        TEXT,
        REAL,
        INTEGER,
        BLOB

    };

    enum class ConflictResolution{
        ABORT ,
        FAIL,
        IGNORE,
        REPLACE,
        ROLLBACK

    };
    enum class TriggerConflictResolution{
        NORESO,
        DELETE,
        UPDATE
    };
    enum class ForeignKeyAction{
        NOACTION,
        CASCADE ,
        SETNULL,
        SETDEFAULT,
        RESTRICT
    };
    Q_ENUM_NS(ConflictResolution)
    Q_ENUM_NS(TriggerConflictResolution)
    Q_ENUM_NS(ForeignKeyAction)
    Q_ENUM_NS(SQLiteDataType)
}


#endif // SQLITEDATATYPE_H
