pragma Singleton
import QtQuick 2.15
import Com.Plm.PeakMapPH 1.0
import "db"
import "./network/graphql/"
QtObject{
    property string _config : "qrc:/qml/config.json"
    property FileSystem fs: FileSystem{

    }
    property string backend_api

    property var initConfig: ()=>{
        var data = JSON.parse(fs.readFileString(_config))
        backend_api = data.backend_api

    }

    property Database db:Database{}
    property string currentBusId
    property string currentBusName
    property GraphqlTransportWS gtransport: GraphqlTransportWS{
        onConnectionOkay: {
            console.log("GraphQL Subsciption engine is running")
        }
    }
}
