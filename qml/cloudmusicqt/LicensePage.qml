import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: licensePage

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }

    Flickable {
        width: parent.width
        contentHeight: flickableContent.height
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent
        anchors.margins: platformStyle.paddingMedium

        Column {
            id: flickableContent

            ViewHeader {
                id: viewHeader
                title: "第三方软件许可"
            }

            Text {
                color: platformStyle.colorNormalLight
                anchors.margins: platformStyle.paddingMedium
                font.pixelSize: platformStyle.fontSizeLarge
                text: 'QJson'
                anchors {
                    left: parent.left
                    right: parent.right
                }
                wrapMode: Text.WordWrap
            }

            Text {
                color: platformStyle.colorNormalLight
                anchors.margins: platformStyle.paddingMedium
                font.pixelSize: platformStyle.fontSizeMedium
                text: 'Copyright © 2012 - Flavio Castelli'
                anchors {
                    left: parent.left
                    right: parent.right
                }
                wrapMode: Text.WordWrap
            }

            Text {
                color: platformStyle.colorNormalLight
                anchors.margins: platformStyle.paddingMedium
                font.pixelSize: platformStyle.fontSizeMedium
                text: '<a href="https://qjson.sourceforge.net">https://qjson.sourceforge.net</a>'
                onLinkActivated: Qt.openUrlExternally(link)
                anchors {
                    left: parent.left
                    right: parent.right
                }
                wrapMode: Text.WordWrap
            }

            Text {
                color: platformStyle.colorNormalLight
                anchors.margins: platformStyle.paddingMedium
                font.pixelSize: platformStyle.fontSizeMedium
                text: '<a href="https://www.gnu.org/licenses/old-licenses/lgpl-2.1-standalone.html">GNU LESSER GENERAL PUBLIC LICENSE Version 2.1</a>'
                onLinkActivated: Qt.openUrlExternally(link)
                anchors {
                    left: parent.left
                    right: parent.right
                }
                wrapMode: Text.WordWrap
            }

            Text {
                color: platformStyle.colorNormalLight
                anchors.margins: platformStyle.paddingMedium
                font.pixelSize: platformStyle.fontSizeLarge
                text: '\n\nQR-Code-generator'
                anchors {
                    left: parent.left
                    right: parent.right
                }
                wrapMode: Text.WordWrap
            }

            Text {
                color: platformStyle.colorNormalLight
                anchors.margins: platformStyle.paddingMedium
                font.pixelSize: platformStyle.fontSizeMedium
                text: 'Copyright © 2024 Project Nayuki. (MIT License)'
                onLinkActivated: Qt.openUrlExternally(link)
                anchors {
                    left: parent.left
                    right: parent.right
                }
                wrapMode: Text.WordWrap
            }

            Text {
                color: platformStyle.colorNormalLight
                anchors.margins: platformStyle.paddingMedium
                font.pixelSize: platformStyle.fontSizeMedium
                text: '<a href="https://www.nayuki.io/page/qr-code-generator-library">https://www.nayuki.io/page/qr-code-generator-library</a>\n\n'
                onLinkActivated: Qt.openUrlExternally(link)
                anchors {
                    left: parent.left
                    right: parent.right
                }
                wrapMode: Text.WordWrap
            }

            Text {
                color: platformStyle.colorNormalLight
                anchors.margins: platformStyle.paddingMedium
                font.pixelSize: platformStyle.fontSizeSmall
                text: 'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n' +
                'The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n' +
                'The Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.'
                anchors {
                    left: parent.left
                    right: parent.right
                }
                wrapMode: Text.WordWrap
            }


        }
    }

}
