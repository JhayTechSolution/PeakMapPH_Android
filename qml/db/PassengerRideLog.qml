import QtQuick 2.15

import Com.Plm.PeakMapPH 1.0
SQLiteTable{
    id: root
   property SQLiteProperty uid: SQLiteProperty{
        dataType: SQLite.INTEGER
        isPrimaryKey: true
        isAutoIncrement: true

   }
   property SQLiteProperty uniqueId :SQLiteProperty{
        dataType: SQLite.TEXT
        nullable: false
   }

   property SQLiteProperty busName: SQLiteProperty{
        dataType: SQLite.TEXT
        nullable:true

   }
   property SQLiteProperty busId: SQLiteProperty{
        dataType: SQLite.INTEGER
        nullable:true
        defaultValue: -1
    }

   property SQLiteProperty createdAt: SQLiteProperty{
        dataType: SQLite.INTEGER
        defaultValue: "(datetime('now'))"
        nullable:false
   }
   property SQLiteProperty updatedAt: SQLiteProperty{
        dataType: SQLite.INTEGER
    }
    property SQLiteProperty deletedAt: SQLiteProperty{
        dataType:SQLite.INTEGER
    }

    property SQLiteProperty deleted: SQLiteProperty{
        dataType: SQLite.INTEGER
        defaultValue: 0
    }

    keys: [
        SQLiteForeignKey{
            columns: [root.uniqueId]
            referenceTable: UserTable{
                id:uTable
            }
            referenceColumns: [uTable.uniqueId]

        }
    ]
}
