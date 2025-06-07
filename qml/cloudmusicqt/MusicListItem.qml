import QtQuick 1.1
import com.nokia.symbian 1.1

ListItemFrame {
    id: root

    property bool active: false
    property bool showIndex: false
    property alias upperTag: upperTagText.text
    property alias lowerTag: lowerTagText.text
    property alias title: titleText.text
    property alias subTitle: subTitleText.text

    Loader {
        id: indicatorLoader
        sourceComponent: active ? indicatorComponent : undefined
        Component {
            id: indicatorComponent
            Image {
                height: root.height
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                source: "gfx/qtg_graf_unread_indicator.svg"
            }
        }
    }

    Text {
        id: indexText
        width: platformStyle.graphicSizeMedium
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: platformStyle.fontSizeLarge
        color: platformStyle.colorNormalMid
        text: index + 1
        visible: showIndex
    }

    Column {
        anchors {
            left: showIndex ? indexText.right : parent.left;
            leftMargin: showIndex ? 0 : platformStyle.paddingLarge
            right: upperTag != "" || lowerTag != "" ? tagColumn.left : parent.right
            rightMargin: upperTag != "" || lowerTag != "" ? 0 : platformStyle.paddingLarge
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

    Column {
        id: tagColumn
        spacing: 11

        anchors {
            top: parent.top
            topMargin: platformStyle.paddingSmall
            bottom: parent.bottom
            bottomMargin: platformStyle.paddingSmall
            right: parent.right
            rightMargin: platformStyle.paddingSmall
        }

        Rectangle {
            id: upperTagRect
            width: upperTagText.width + platformStyle.paddingSmall
            height: parent.height / 2.5
            color: platformStyle.colorNormalDark
            radius: 4
            border.width: 2
            border.color: platformStyle.colorNormalLight
            visible: upperTag != ""

            Text {
                id: upperTagText
                text: ""
                color: platformStyle.colorNormalLight
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 7
                horizontalAlignment: Text.AlignRight
            }

        }

        Rectangle {
            id: lowerTagRect
            width: lowerTagText.width + platformStyle.paddingSmall
            height: parent.height / 2.5
            color: platformStyle.colorNormalDark
            radius: 4
            border.width: 2
            border.color: platformStyle.colorNormalLight
            visible: lowerTag != ""

            Text {
                id: lowerTagText
                text: ""
                color: platformStyle.colorNormalLight
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 7
                horizontalAlignment: Text.AlignRight
            }
        }
    }


}
