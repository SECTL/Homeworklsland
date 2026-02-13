import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

Item {
    id: root
    signal openRequested()

    Rectangle {
        id: bubble
        anchors.fill: parent
        radius: width / 2
        color: "#E3C79E"
        border.color: "#B88945"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: "作业"
            font.pixelSize: 18
            color: "#3B2E24"
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            if (root.Window.window) {
                root.Window.window.startSystemMove()
            }
        }
        onClicked: root.openRequested()
    }
}
