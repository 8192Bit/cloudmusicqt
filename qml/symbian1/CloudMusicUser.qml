import QtQuick 1.0
import "../js/api.js" as Api

QtObject {
    id: user

    property bool loggedIn: false

    signal userChanged;

    function initialize() {
        var token = qmlApi.getCookieToken()
        var uid = qmlApi.getUserId()

        console.log("initializing")
        console.log("token "+token)
        console.log("uid   "+uid)
        loggedIn = token != "" && uid != ""
        userChanged()
        if (loggedIn) {

            console.log("sadfafdsfsiyhoiuoojuoijoi")
            collector.refresh()
            refreshUserToken(token)
        } else {
            console.log("fuck~~~~~~~~~~~~~~")
        }
    }

    function refreshUserToken(token) {
        var f = function(err) {
            console.log("refresh token failed: ", err)
            if (err != 0) {
                loggedIn = false
                userChanged()
            }
        }
        Api.refreshToken(token, new Function(), f)
    }
}
