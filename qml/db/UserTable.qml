import QtQuick 2.15
import Com.Plm.PeakMapPH 1.0

SQLiteTable{
    id: root
    tableName: "Users"
    property SQLiteProperty uniqueId:SQLiteProperty{
        dataType: SQLite.TEXT
        isPrimaryKey: true
        isAutoIncrement: false

    }

}
