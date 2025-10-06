import QtQuick 2.15

import Com.Plm.PeakMapPH 1.0
SQLiteTable{
    id: root
   property SQLiteProperty rideId: SQLiteProperty{
        dataType: SQLite.INTEGER
        isPrimaryKey: true
        isAutoIncrement: true

   }
   property SQLiteProperty busId: SQLiteProperty{
       dataType: SQLite.TEXT

   }
   property SQLiteProperty active: SQLiteProperty{
        dataType: SQLite.INTEGER
    }
    property SQLiteProperty busLatitude: SQLiteProperty {
        dataType: SQLite.REAL
    }
    property SQLiteProperty busLongitude: SQLiteProperty {
        dataType: SQLite.REAL
    }

    property SQLiteProperty createdAt: SQLiteProperty {
        dataType: SQLite.INTEGER
    }
    property SQLiteProperty createdKey: SQLiteProperty{
        dataType: SQLite.TEXT
    }
    property SQLiteProperty busName: SQLiteProperty{
        dataType: SQLite.TEXT
    }
    property SQLiteProperty maxCapacity: SQLiteProperty{
        dataType: SQLite.INTEGER
    }
    property SQLiteProperty currentLoad: SQLiteProperty{
        dataType: SQLite.INTEGER
    }
    property SQLiteProperty congestionLevel: SQLiteProperty{
        dataType:SQLite.TEXT
    }
    property SQLiteProperty routeName : SQLiteProperty{
        dataType :SQLite.TEXT
    }
}
