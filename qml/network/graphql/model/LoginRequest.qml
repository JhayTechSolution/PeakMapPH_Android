import QtQuick 2.15
import "../"
CoreGraphQL{
    methodName: "login"
    graphqlType: GraphQLType.mutationType
    hasInput: true
    queryInput: CoreInput{
        property var input: CoreInputMarker{
            dataType: "LoginInput"
            isRequired: true
            value: LoginInput{
                id: loginInput
            }
        }
    }
    queryResponse: AccountInfo{}
    property alias username: loginInput.user
    property alias password: loginInput.pwd
}
