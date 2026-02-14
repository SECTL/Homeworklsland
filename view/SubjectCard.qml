import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: root
    property string subjectName: ""
    property var modelRef
    property real uiScale: 1.0
    property string appFontFamily: ""
    property color cardColor: "#FFFFFF"
    property color borderColor: "#E1D6C8"
    property color textPrimaryColor: "#3B2E24"
    property color textSecondaryColor: "#5B4A3C"

    radius: Math.round(12 * root.uiScale)
    color: root.cardColor
    border.color: root.borderColor
    border.width: 1
    height: listColumn.implicitHeight + Math.round(20 * root.uiScale)

    Column {
        id: listColumn
        anchors.fill: parent
        anchors.margins: Math.round(12 * root.uiScale)
        spacing: Math.round(6 * root.uiScale)

        Text {
            text: subjectName
            font.pixelSize: Math.round(16 * root.uiScale)
            font.family: root.appFontFamily
            font.bold: true
            color: root.textPrimaryColor
        }

        Repeater {
            model: modelRef
            delegate: Column {
                spacing: Math.round(2 * root.uiScale)

                Text {
                    text: "• " + title
                    font.pixelSize: Math.round(13 * root.uiScale)
                    font.family: root.appFontFamily
                    color: root.textPrimaryColor
                    wrapMode: Text.Wrap
                }

                Text {
                    visible: detail.length > 0
                    text: detail
                    font.pixelSize: Math.round(11 * root.uiScale)
                    font.family: root.appFontFamily
                    color: root.textSecondaryColor
                    wrapMode: Text.Wrap
                }

                Text {
                    visible: note.length > 0
                    text: "备注: " + note
                    font.pixelSize: Math.round(11 * root.uiScale)
                    font.family: root.appFontFamily
                    color: root.textSecondaryColor
                    wrapMode: Text.Wrap
                }

                Text {
                    visible: tags.length > 0
                    text: "标签: " + tags
                    font.pixelSize: Math.round(11 * root.uiScale)
                    font.family: root.appFontFamily
                    color: "#8A5B3B"
                    wrapMode: Text.Wrap
                }

                Rectangle {
                    height: 1
                    width: parent.width
                    color: "#EFE7DA"
                }
            }
        }

        Text {
            visible: modelRef && modelRef.count === 0
            text: "暂无作业"
            font.pixelSize: Math.round(12 * root.uiScale)
            font.family: root.appFontFamily
            color: "#A08C7A"
        }
    }
}
