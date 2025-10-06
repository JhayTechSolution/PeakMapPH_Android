import QtQuick 2.15
import Com.Plm.PeakMapPH 1.0
SQLiteDB{
    db: "peakmap.db"
    onDbOpen: {

    }

    tables: [
        UserTable{},
        PassengerRideLog{},
        LiveSpeedLocation{},
        ReportedCongestion{},
        AlertCongestion{}
    ]
    Component.onCompleted: {
        open()


    }
}
