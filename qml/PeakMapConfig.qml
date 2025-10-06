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
    property string version
    property var initConfig: ()=>{
        var data = JSON.parse(fs.readFileString(_config))
        backend_api = data.backend_api
        version  = data.versionname
    }
    id: root
    property Database db:Database{}
    property string currentBusId
    property string currentBusName
    property GraphqlTransportWS gtransport: GraphqlTransportWS{
        url: root.backend_api.replace("http://","ws://").replace("https://","wss://")
        onConnectionOkay: {
            console.log("GraphQL Subsciption engine is running")
        }
    }
    function formatDateNow() {
      const date = new Date(Date.now());

      const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are 0-based
      const day = String(date.getDate()).padStart(2, '0');
      const year = date.getFullYear();

      return `${month}${day}${year}`;
    }




}
