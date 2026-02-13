import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

Item {
    id: root
    property var subjectEntries: []

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
        height: 120
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
            anchors.margins: 16
            spacing: 6

            RowLayout {
                spacing: 12
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    id: timeText
                    font.pixelSize: 28
                    font.bold: true
                    color: "#3B2E24"
                    text: ""
                }

                Item { Layout.fillWidth: true }
            }

            Text {
                id: dateText
                font.pixelSize: 14
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
