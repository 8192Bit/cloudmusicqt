import QtQuick 1.1

Item {
    width: parent.itemWidth
    height: width + platformStyle.graphicSizeLarge

    property int id: 0

    property alias imageUrl: image.source
    property alias upperText: upperTagText.text
    property alias lowerText: lowerTagText.text

    signal onItemClicked(int id)

    Image {
        id: image
        width: parent.width
        height: parent.width
        source: Api.getScaledImageUrl(picUrl, 160)
    }
    Text {
        id: upperText
        anchors { top: coverImage.bottom; topMargin: platformStyle.paddingMedium }
        width: parent.width
        elide: Text.ElideRight
        wrapMode: Text.Wrap
        maximumLineCount: 2
        font.pixelSize: platformStyle.fontSizeMedium
        color: "white"
    }
    Text {
        id: lowerText
        visible: lowerText != ""
        anchors { top: upperText.bottom; topMargin: platformStyle.paddingMedium }
        width: parent.width
        elide: Text.ElideRight
        wrapMode: Text.Wrap
        maximumLineCount: 1
        font.pixelSize:00
        color: "white"
    }
    MouseArea {
        anchors.fill: parent
        onPressed: parent.opacity = 0.8
        onReleased: parent.opacity = 1
        onCanceled: parent.opacity = 1
        onClicked: {
            onItemClicked(id)
        }
    }
}
