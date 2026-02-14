import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

Item {
    id: root
    property var subjectEntries: []
    property real uiScale: 1.0

    implicitHeight: header.height

    function updateTime() {
        var d = new Date()
        var week = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        var h = d.getHours().toString().padStart(2, "0")
        var m = d.getMinutes().toString().padStart(2, "0")
        var s = d.getSeconds().toString().padStart(2, "0")
        timeText.text = h + ":" + m + ":" + s
        dateText.text = d.getFullYear() + "年" + (d.getMonth() + 1) + "月" + d.getDate() + "日  " + week[d.getDay()]
    }

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Math.round(120 * root.uiScale)
        color: "#EFE7DA"

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onPressed: {
                if (root.Window.window && root.Window.window.startSystemMove) {
                    root.Window.window.startSystemMove()
                }
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: Math.round(16 * root.uiScale)
            spacing: Math.round(6 * root.uiScale)

            RowLayout {
                spacing: Math.round(12 * root.uiScale)
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    id: timeText
                    font.pixelSize: Math.round(28 * root.uiScale)
                    font.bold: true
                    color: "#3B2E24"
                    text: ""
                }

                Item { Layout.fillWidth: true }
            }

            Text {
                id: dateText
                font.pixelSize: Math.round(14 * root.uiScale)
                color: "#5B4A3C"
                text: ""
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: root.updateTime()
        }

        Component.onCompleted: root.updateTime()
    }
}
