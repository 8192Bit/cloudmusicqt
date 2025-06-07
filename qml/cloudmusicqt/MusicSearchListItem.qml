import QtQuick 1.1
import com.nokia.symbian 1.1

ListItemFrame {
    id: root

    property alias title: titleText.text
    property alias subTitle: subTitleText.text
    property alias imageUrl: image.source

    Image {
        id: image
    }


    Column {
        anchors {
            left: image.left;
            leftMargin: platformStyle.paddingMedium
            right: parent.right
            rightMargin: platformStyle.paddingLarge
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
