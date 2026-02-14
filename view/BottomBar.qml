import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: root
    property real uiScale: 1.0
    property string appFontFamily: ""
    property color bgColor: "#F5EFE6"
    property color borderColor: "#E1D6C8"
    signal requestAssign()
    signal requestSettings()
    signal toggleFullscreen()
    signal requestExit()
    signal requestHide()

    height: Math.round(56 * root.uiScale)
    color: root.bgColor
    border.color: root.borderColor
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: Math.round(10 * root.uiScale)
        spacing: Math.round(8 * root.uiScale)

        Button {
            text: "布置新作业"
            font.pixelSize: Math.round(12 * root.uiScale)
            font.family: root.appFontFamily
            height: Math.round(32 * root.uiScale)
            padding: Math.round(6 * root.uiScale)
            onClicked: root.requestAssign()
        }

        Item { Layout.fillWidth: true }

        RowLayout {
            spacing: Math.round(6 * root.uiScale)

            Button {
                text: "设置"
                font.pixelSize: Math.round(12 * root.uiScale)
                font.family: root.appFontFamily
                height: Math.round(32 * root.uiScale)
                padding: Math.round(6 * root.uiScale)
                onClicked: root.requestSettings()
            }
            Button {
                text: "全屏"
                font.pixelSize: Math.round(12 * root.uiScale)
                font.family: root.appFontFamily
                height: Math.round(32 * root.uiScale)
                padding: Math.round(6 * root.uiScale)
                onClicked: root.toggleFullscreen()
            }
            Button {
                text: "收起"
                font.pixelSize: Math.round(12 * root.uiScale)
                font.family: root.appFontFamily
                height: Math.round(32 * root.uiScale)
                padding: Math.round(6 * root.uiScale)
                onClicked: root.requestHide()
            }
            Button {
                text: "退出"
                font.pixelSize: Math.round(12 * root.uiScale)
                font.family: root.appFontFamily
                height: Math.round(32 * root.uiScale)
                padding: Math.round(6 * root.uiScale)
                onClicked: root.requestExit()
            }
        }
    }
}
