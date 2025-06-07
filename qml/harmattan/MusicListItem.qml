import QtQuick 1.1
import "./UIConstants.js" as UI

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
        width: UI.LIST_ITEM_HEIGHT_SMALL
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: UI.FONT_LARGE
        color: UI.COLOR_INVERTED_SECONDARY_FOREGROUND
        text: index + 1
        visible: showIndex
    }

    Column {
        anchors {
            left: showIndex ? indexText.right : parent.left;
            leftMargin: showIndex ? 0 : UI.PADDING_LARGE
            right: upperTag != "" || lowerTag != "" ? tagColumn.left : parent.right
            rightMargin: upperTag != "" || lowerTag != "" ? 0 : UI.PADDING_LARGE
            verticalCenter: parent.verticalCenter
        }
        spacing: UI.PADDING_SMALL

        Text {
            id: titleText
            width: parent.width
            font.pixelSize: UI.FONT_LARGE
            color: UI.COLOR_INVERTED_FOREGROUND
            elide: Text.ElideRight
        }

        Text {
            id: subTitleText
            width: parent.width
            font.pixelSize: UI.FONT_SMALL
            color: UI.COLOR_INVERTED_SECONDARY_FOREGROUND
            elide: Text.ElideRight
        }
    }


    Column {
        id: tagColumn
        spacing: UI.PADDING_LARGE

        anchors {
            top: parent.top
            topMargin: UI.PADDING_SMALL
            bottom: parent.bottom
            bottomMargin: UI.PADDING_SMALL
            right: parent.right
            rightMargin: UI.PADDING_SMALL
        }

        Rectangle {
            id: upperTagRect
            width: upperTagText.width + UI.PADDING_SMALL
            height: parent.height / 2.5
            color: "transparent"
            radius: 4
            border.width: 2
            border.color: UI.COLOR_INVERTED_FOREGROUND
            visible: upperTag != ""

            Text {
                id: upperTagText
                text: ""
                color: UI.COLOR_INVERTED_FOREGROUND
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
            color: "transparent"
            radius: 4
            border.width: 2
            border.color: UI.COLOR_INVERTED_FOREGROUND
            visible: lowerTag != ""

            Text {
                id: lowerTagText
                text: ""
                color: UI.COLOR_INVERTED_FOREGROUND
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 7
                horizontalAlignment: Text.AlignRight
            }
        }
    }



}
