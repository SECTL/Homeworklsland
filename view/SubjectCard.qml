import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: root
    property string subjectName: ""
    property var modelRef

    radius: 12
    color: "#FFFFFF"
    border.color: "#E1D6C8"
    border.width: 1
    height: listColumn.implicitHeight + 20

    Column {
        id: listColumn
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        Text {
            text: subjectName
            font.pixelSize: 16
            font.bold: true
            color: "#3B2E24"
        }

        Repeater {
            model: modelRef
            delegate: Column {
                spacing: 2

                Text {
                    text: "• " + title
                    font.pixelSize: 13
                    color: "#3B2E24"
                    wrapMode: Text.Wrap
                }

                Text {
                    visible: detail.length > 0
                    text: detail
                    font.pixelSize: 11
                    color: "#6C5B4C"
                    wrapMode: Text.Wrap
                }

                Text {
                    visible: note.length > 0
                    text: "备注: " + note
                    font.pixelSize: 11
                    color: "#7A6757"
                    wrapMode: Text.Wrap
                }

                Text {
                    visible: tags.length > 0
                    text: "标签: " + tags
                    font.pixelSize: 11
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
            font.pixelSize: 12
            color: "#A08C7A"
        }
    }
}
