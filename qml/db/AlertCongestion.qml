import QtQuick 2.15

import Com.Plm.PeakMapPH 1.0
SQLiteTable{
    id: root
   property SQLiteProperty alertId: SQLiteProperty{
        dataType: SQLite.INTEGER
        isPrimaryKey: true
        isAutoIncrement: true

   }
    property SQLiteProperty latitude: SQLiteProperty{
        dataType:SQLite.REAL

    }
    property SQLiteProperty longitude: SQLiteProperty{
        dataType: SQLite.REAL
    }
    property SQLiteProperty createdKey: SQLiteProperty{
        dataType: SQLite.TEXT
    }

    property SQLiteProperty createdAt: SQLiteProperty{
        dataType: SQLite.INTEGER
    }
    property SQLiteProperty routeName: SQLiteProperty{
        dataType: SQLite.TEXT
    }
    property SQLiteProperty level: SQLiteProperty{
        dataType:SQLite.TEXT

    }

}
