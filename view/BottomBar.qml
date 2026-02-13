import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: root
    signal requestAssign()
    signal requestSettings()
    signal toggleFullscreen()
    signal requestExit()
    signal requestHide()

    height: 56
    color: "#F5EFE6"
    border.color: "#E1D6C8"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Button {
            text: "布置新作业"
            font.pixelSize: 12
            height: 32
            padding: 6
            onClicked: root.requestAssign()
        }

        Item { Layout.fillWidth: true }

        RowLayout {
            spacing: 6

            Button {
                text: "设置"
                font.pixelSize: 12
                height: 32
                padding: 6
                onClicked: root.requestSettings()
            }
            Button {
                text: "全屏"
                font.pixelSize: 12
                height: 32
                padding: 6
                onClicked: root.toggleFullscreen()
            }
            Button {
                text: "收起"
                font.pixelSize: 12
                height: 32
                padding: 6
                onClicked: root.requestHide()
            }
            Button {
                text: "退出"
                font.pixelSize: 12
                height: 32
                padding: 6
                onClicked: root.requestExit()
            }
        }
    }
}
