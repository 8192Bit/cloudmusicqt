import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: page

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: mainMenu.open()
        }
    }

    Menu {
        id: mainMenu
        MenuLayout {
            MenuItem {
                text: "第三方软件许可";
                onClicked: pageStack.push(Qt.resolvedUrl("LicensePage.qml"));
            }
        }
    }

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: app.inPortrait ? platformStyle.graphicSizeLarge : 0
        }
        spacing: platformStyle.paddingMedium

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.width: platformStyle.graphicSizeLarge * 2.5
            sourceSize.height: platformStyle.graphicSizeLarge * 2.5
            source: "gfx/cloudmusicqt.svg"
        }

        Label {
            font.pixelSize: platformStyle.fontSizeLarge + 4
            anchors.horizontalCenter: parent.horizontalCenter
            text: "网易云音乐测试版"
        }

        ListItemText {
            anchors.horizontalCenter: parent.horizontalCenter
            role: "SubTitle"
            text: "软件版本号: " + appVersion
        }

        ListItemText {
            anchors.horizontalCenter: parent.horizontalCenter
            role: "SubTitle"
            text: "Qt库版本号: " + qtVersion
        }
    }

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom; bottomMargin: platformStyle.paddingMedium
        }
        visible: screen.height > 360
        ListItemText {
            anchors.horizontalCenter: parent.horizontalCenter
            role: "SubTitle"
            text: "Designed & built by Yeatse, 2015"
        }

        ListItemText {
            anchors.horizontalCenter: parent.horizontalCenter
            role: "SubTitle"
            text: "Maintained by Karin, 2019 & 8192Bit, 2025"
        }

    }

}
