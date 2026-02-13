import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    property var subjectOptions: []
    signal subjectEnabledUpdated(string name, bool enabled)
    signal subjectAdded(string name)

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: content.implicitHeight + 24
        clip: true

        ColumnLayout {
            id: content
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            spacing: 12

            Label {
                text: "学科管理"
                font.pixelSize: 22
                font.bold: true
            }

            Label {
                text: "启用/禁用学科"
                font.pixelSize: 14
                opacity: 0.8
            }

            Repeater {
                model: root.subjectOptions

                delegate: Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 48
                    radius: 10
                    color: "#FFFFFF"
                    border.color: "#E3DED4"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        Label {
                            text: modelData.name
                            font.pixelSize: 15
                        }

                        Item { Layout.fillWidth: true }

                        Switch {
                            checked: modelData.enabled
                            onToggled: root.subjectEnabledUpdated(modelData.name, checked)
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(0, 0, 0, 0.12)
            }

            Label {
                text: "新增学科"
                font.pixelSize: 14
                opacity: 0.8
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                TextField {
                    id: addSubjectField
                    Layout.fillWidth: true
                    placeholderText: "输入学科名称（例如：化学）"
                }

                Button {
                    text: "添加"
                    onClicked: {
                        var name = addSubjectField.text.trim()
                        if (name.length === 0) {
                            return
                        }
                        root.subjectAdded(name)
                        addSubjectField.text = ""
                    }
                }
            }
        }
    }
}
