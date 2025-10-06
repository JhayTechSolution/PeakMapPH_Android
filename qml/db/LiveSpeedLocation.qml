import QtQuick 2.15

import Com.Plm.PeakMapPH 1.0
SQLiteTable{
    id: root
   property SQLiteProperty speedId: SQLiteProperty{
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
    property SQLiteProperty createdDate: SQLiteProperty{
        dataType: SQLite.INTEGER
    }


}
