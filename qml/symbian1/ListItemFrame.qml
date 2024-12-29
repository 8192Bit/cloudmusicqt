import QtQuick 1.0
import com.nokia.symbian 1.0

Item {
    id: root

    signal clicked
    signal pressAndHold

    width: screen.width
    height: platformStyle.graphicSizeLarge

    MouseArea {
        anchors.fill: parent
        onPressed: root.opacity = 0.8
        onReleased: root.opacity = 1
        onCanceled: root.opacity = 1
        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold()
    }
}
