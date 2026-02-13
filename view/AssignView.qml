import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    property var subjectNames: []
    signal submitAssignment(string subject, string title, bool isExercise, int startPage, int endPage, string note, string tags)

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: form.implicitHeight + 32
        clip: true

        ColumnLayout {
            id: form
            anchors.margins: 18
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10

            Label {
                text: "新作业编辑区"
                font.pixelSize: 22
            }

            ComboBox {
                id: subjectBox
                Layout.fillWidth: true
                font.pixelSize: 16
                implicitHeight: 40
                model: root.subjectNames
            }

            TextField {
                id: titleField
                Layout.fillWidth: true
                font.pixelSize: 16
                implicitHeight: 40
                placeholderText: "作业内容（如：课后题 1-8）"
            }

            CheckBox {
                id: exerciseCheck
                text: "练习册"
                font.pixelSize: 14
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                TextField {
                    id: startPage
                    Layout.fillWidth: true
                    font.pixelSize: 16
                    implicitHeight: 40
                    placeholderText: "起始页"
                    enabled: exerciseCheck.checked
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                TextField {
                    id: endPage
                    Layout.fillWidth: true
                    font.pixelSize: 16
                    implicitHeight: 40
                    placeholderText: "终结页"
                    enabled: exerciseCheck.checked
                    inputMethodHints: Qt.ImhDigitsOnly
                }
            }

            TextArea {
                id: noteArea
                Layout.fillWidth: true
                font.pixelSize: 15
                Layout.preferredHeight: 90
                placeholderText: "备注"
            }

            TextField {
                id: tagsField
                Layout.fillWidth: true
                font.pixelSize: 16
                implicitHeight: 40
                placeholderText: "标签（用逗号分隔，如：放学前必须交,家长签字）"
            }

            Button {
                text: "添加作业"
                Layout.fillWidth: true
                font.pixelSize: 16
                implicitHeight: 42
                enabled: root.subjectNames.length > 0
                onClicked: {
                    var start = parseInt(startPage.text)
                    var end = parseInt(endPage.text)
                    root.submitAssignment(
                        subjectBox.currentText,
                        titleField.text,
                        exerciseCheck.checked,
                        isNaN(start) ? 0 : start,
                        isNaN(end) ? 0 : end,
                        noteArea.text,
                        tagsField.text
                    )
                    titleField.text = ""
                    noteArea.text = ""
                    tagsField.text = ""
                    startPage.text = ""
                    endPage.text = ""
                    exerciseCheck.checked = false
                }
            }
        }
    }
}
