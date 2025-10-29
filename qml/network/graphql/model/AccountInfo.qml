import QtQuick 2.15
import "../"

CoreResponse{
    /*
    type AccountInfo{
        id: String
        fullName:String!
        birthDate:String!
        contactNumber:String!
        emailAddress:String!
        username:String!
        role:AccountType!
    }
    */
    property CoreResponseMarker accountId: CoreResponseMarker{
        propertyName: "id"
        dataType: CoreType.stringType
        include: true
    }
    property CoreResponseMarker fullName: CoreResponseMarker{
        dataType: CoreType.stringType
        include: true
    }
    property CoreResponseMarker birthDate:CoreResponseMarker{
        dataType: CoreType.stringType
        include : true
    }
    property CoreResponseMarker contactNumber: CoreResponseMarker{
        dataType: CoreType.stringType
        include:true
    }
    property CoreResponseMarker emailAddress: CoreResponseMarker{
        dataType: CoreType.stringType
        include: true
    }
    property CoreResponseMarker username: CoreResponseMarker{
        dataType: CoreType.stringType
        include: true
    }
    property CoreResponseMarker role: CoreResponseMarker{
        dataType: CoreType.stringType
        include: true
    }
}
