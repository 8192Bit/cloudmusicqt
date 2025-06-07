import QtQuick 1.0
import com.nokia.symbian 1.1
import com.yeatse.cloudmusic 1.0

import "../js/api.js" as Api

Page {
    id: page

    property string qrKey: "";
    property bool isQrCodeExpired: false;

    LoginApi {
        id: loginApi


        onFailed: {
            console.log("查询二维码状态失败" + error)
            qmlApi.showNotification("查询二维码状态失败", error, 1)
        }

        onResult: {
            if(code == 800) {
                qrCodeStatusText.text = "二维码已过期,请点击刷新按钮以重新获取"
                isQrCodeExpired = true;
            }

            if(code == 801) {
                qrCodeStatusText.text = "请用网易云音乐手机APP扫码"
            }

            if(code == 803) {
                qrCodeStatusText.text = "授权登录成功"
                // SAVVE USER ID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                var s = function(resp) {
                    qmlApi.saveUserId(resp.account.id);
                    user.initialize();
                    qrCodeTimer.stop()
                    successPopTimer.start();
                }
                var f = function(err) {

                }

                Api.getUserDetailByCookie(s, f);
            }
        }


    }

    function refreshQrCodeStatus() {
        if(qrKey == "") {
            refreshQrCode();
        } else {
            // see https://forum.qt.io/topic/25222/get-set-cookies-from-qml/2
            // so C++ API is used here
            loginApi.checkQrCodeStatus(qrKey);
        }
    }

    Timer {
        id: qrCodeTimer
        interval: 3000
        running: true
        repeat: true
        onTriggered: if(!isQrCodeExpired) refreshQrCodeStatus()
        triggeredOnStart: true
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
            qrCodeImage.source = qmlApi.generateSvgQrCode("https://music.163.com/login?codekey="+qrKey);
            isQrCodeExpired = false;
        };
        var f = function(err) {
            qrCodeStatusText = "二维码生成失败"
        };
        Api.generateQrKey(s, f);
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }

    ViewHeader {
        id: viewHeader
        title: "登录"
    }

    Item {
        id: column
        width: parent.width
        height: parent.height
        anchors{
            top: viewHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }


        Image {
            id: qrCodeImage
            height: parent.width > parent.height ? parent.height - platformStyle.fontSizeLarge - 4 * platformStyle.paddingLarge : width
            width: parent.width > parent.height ? height : parent.width - 4 * platformStyle.paddingLarge
            anchors{
                top: parent.top
                margins: platformStyle.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            source: ""
            opacity: isQrCodeExpired ? 0.5 : 1
        }

        Button {
            id: refreshButton
            anchors.centerIn: qrCodeImage
            iconSource: privateStyle.toolBarIconPath("toolbar-refresh")
            visible: isQrCodeExpired
            onClicked: refreshQrCode()
        }

        Text {
            id: qrCodeStatusText
            color: "white"
            text: "加载中"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors{
                top: qrCodeImage.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: platformStyle.paddingLarge
            }
            wrapMode: Text.WordWrap
            font.pixelSize: platformStyle.fontSizeLarge
        }

    }
}

