import QtQuick 1.0
import com.nokia.symbian 1.0
import com.yeatse.cloudmusic 1.0

import "../js/api.js" as Api

Page {
    id: page


    /*
    function performEmailLogin() {
        var s = function(resp, headers) {
            resp.data.
        }
        var f = function(err) {
            console.log("get hot spot failed: ", err)
        }
        Api.loginByEmail(emailAddressField.text, passwordField.text, s, f)
    }
    */

    property string qrKey: "";
    property bool isQrCodeExpired: false;

    function refreshQrCodeStatus() {
        if(qrKey == "") {
            refreshQrCode();
        } else {
            // see https://forum.qt.io/topic/25222/get-set-cookies-from-qml/2
            // so C++ API is used here
            var result = loginApi.checkQrCodeStatus(qrKey);
            if(result == 800) {
                qrCodeStatusText.text = "二维码已过期,请点击刷新按钮以重新获取"
                isQrCodeExpired = true;
            }

            if(result == 801) {
                qrCodeStatusText.text = "请用网易云音乐手机APP扫码"
            }

            if(result == 803) {
                qrCodeStatusText.text = "授权登录成功"
                // SAVVE USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                var s = function(resp) {
                    qmlApi.saveUserId(resp.account.id);
                    user.initialize();
                    successPopTimer.start();
                }
                var f = function(err) {

                }

                Api.getUserDetailByCookie(s, f);
            }
        }
    }

    Timer {
        id: successPopTimer
        running: false
        triggeredOnStart: false
        interval: 3000
        onTriggered: pageStack.pop()
    }

    function refreshQrCode() {
        var s = function(resp) {
            qrKey = resp.unikey
            console.log("qrKey is "+qrKey);
            qrCodeImage.source = qmlApi.generateSvgQrCode("https://music.163.com/login?codekey="+qrKey);
            isQrCodeExpired = false;
        };
        var f = function(err) {
            console.log("failed fetching qrkey");
        };
        Api.generateQrKey(s, f);
    }

    tools: ToolBarLayout {
        width: parent.width
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }

    Column {
        id: column
        width: parent.width
        height: parent.height


        ViewHeader {
            id: viewHeader
            height: 60
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            title: "登录"
        }

        TabBar {
            id: tabbar
            visible: false
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            TabButton {
                id: qrButton
                text: "二维码登录"
                tab: qrCodePage
                onClicked: qrCodeTimer.start()
            }

            TabButton {
                id: emailButton
                text: "邮箱登录"
                tab: emailPage
                onClicked: qrCodeTimer.stop()
            }
        }

        TabGroup {
            id: tabgroup
            anchors.bottom: parent.bottom
            anchors.top: tabbar.bottom
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Page {
                id: qrCodePage
                anchors.top: viewHeader.bottom
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                Timer {
                    id: qrCodeTimer
                    interval: 3000
                    running: true // with mail login, set to false
                    repeat: true
                    onTriggered: if(!isQrCodeExpired) refreshQrCodeStatus()
                    triggeredOnStart: true
                }

                Image {
                    id: qrCodeImage
                    width: parent.height/1.8
                    height: width
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: ""

                    Rectangle {
                        id: qrCodeExpireMask
                        color: isQrCodeExpired ? Qt.rgba(0, 0, 0, 0.5) : Qt.rgba(0, 0, 0, 0);
                        anchors.fill: parent
                    }

                    Button {
                        id: refreshButton
                        anchors.centerIn: parent
                        iconSource: privateStyle.toolBarIconPath("toolbar-refresh")
                        visible: isQrCodeExpired
                        onClicked: refreshQrCode()
                    }


                }

                Text {
                    id: qrCodeStatusText
                    height: 24
                    color: "#ffffff"
                    text: "加载中"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottomMargin: parent.height/10
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottom: parent.bottom
                    styleColor: "#ffffff"
                    smooth: false
                    wrapMode: Text.WordWrap
                    font.pixelSize: 24
                }

            }

            Page {
                id: emailPage
                visible: false
                anchors.fill: parent

                Text {
                    id: emailAddressText
                    x: emailAddressField.x
                    height: 26
                    color: "#ffffff"
                    text: "邮箱地址"
                    visible: false
                    anchors.bottomMargin: 5
                    anchors.bottom: emailAddressField.top
                    font.underline: false
                    style: Text.Normal
                    font.pixelSize: 24
                }

                TextField {
                    id: emailAddressField
                    height: 50
                    visible: false
                    placeholderText: "输入邮箱地址"
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                }

                Text {
                    id: passwordText
                    x: passwordField.x
                    height: 26
                    color: "#ffffff"
                    text: "密码"
                    visible: false
                    anchors.bottomMargin: 5
                    font.pixelSize: 24
                    anchors.bottom: passwordField.top
                    style: Text.Normal
                    font.underline: false
                }

                TextField {
                    id: passwordField
                    height: 50
                    visible: false
                    echoMode: TextInput.Password
                    placeholderText: "输入密码"
                    anchors.topMargin: 40
                    anchors.top: emailAddressField.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                }

                ToolButton {
                    id: loginButton
                    text: "登录"
                    visible: false
                    anchors.topMargin: 20
                    flat: false
                    anchors.top: passwordField.bottom
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: performEmailLogin()
                }



            }


        }


    }


}
