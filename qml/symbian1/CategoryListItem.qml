import QtQuick 1.0
import com.nokia.symbian 1.0

ListItemFrame {
    id: root

    property alias iconSource: icon.source
    property alias title: titleText.text
    property alias subTitle: subTitleText.text

    height: platformStyle.graphicSizeLarge + platformStyle.paddingLarge

    Image {
        id: icon
        anchors {
            left: parent.left; top: parent.top; bottom: parent.bottom
            margins: platformStyle.paddingLarge
        }
        width: height
        sourceSize { width: width; height: height }
    }

    Column {
        anchors {
            left: icon.right; leftMargin: platformStyle.paddingMedium
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        spacing: platformStyle.paddingSmall

        Text {
            id: titleText
            width: parent.width
            font.pixelSize: platformStyle.fontSizeLarge
            color: platformStyle.colorNormalLight
            elide: Text.ElideRight
        }

        Text {
            id: subTitleText
            width: parent.width
            font.pixelSize: platformStyle.fontSizeSmall
            color: platformStyle.colorNormalMid
            elide: Text.ElideRight
        }
    }
}
