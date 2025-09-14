pragma Singleton
import QtQuick 2.15

QtObject{
    property string queryType :"query"
    property string mutationType: "mutation"
    property string subscriptionType :"subscription"
}
