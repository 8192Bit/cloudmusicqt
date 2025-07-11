import QtQuick 1.0
import com.nokia.symbian 1.0

Page {
    id: page1

    tools: ToolBarLayout {
        id: toolbarlayout1
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }


    Rectangle {
        id: rectangle1
        width: 360
        height: 60
        color: "#000000"
        z: 1
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        ViewHeader {
            id: viewheader1
            anchors.top: parent.top
            title: "第三方软件许可"
            anchors.right: parent.right
            anchors.left: parent.left
        }
    }

    Flickable {
        id: flickable1
        width: 360
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 40
        contentWidth: width
        contentHeight: height
        anchors.bottom: parent.bottom
        boundsBehavior: Flickable.DragAndOvershootBounds
        flickableDirection: Flickable.VerticalFlick
        anchors.top: rectangle1.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        Text {
            id: text1
            color: "#ffffff"
            text: 'QR-Code-generator\nCopyright © 2024 Project Nayuki. (MIT License)\nhttps://www.nayuki.io/page/qr-code-generator-library\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nThe Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.'
            z: -1
wrapMode: Text.WordWrap
anchors.fill: parent
            font.pixelSize: 14
        }
    }



}
