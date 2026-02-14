import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    property var subjectNames: []
    property real uiScale: 1.0
    signal submitAssignment(string subject, string title, bool isExercise, int startPage, int endPage, string note, string tags)

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: form.implicitHeight + Math.round(32 * root.uiScale)
        clip: true

        ColumnLayout {
            id: form
            anchors.margins: Math.round(18 * root.uiScale)
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Math.round(10 * root.uiScale)

            Label {
                text: "新作业编辑区"
                font.pixelSize: Math.round(22 * root.uiScale)
            }

            ComboBox {
                id: subjectBox
                Layout.fillWidth: true
                font.pixelSize: Math.round(16 * root.uiScale)
                implicitHeight: Math.round(40 * root.uiScale)
                model: root.subjectNames
            }

            TextField {
                id: titleField
                Layout.fillWidth: true
                font.pixelSize: Math.round(16 * root.uiScale)
                implicitHeight: Math.round(40 * root.uiScale)
                placeholderText: "作业内容（如：课后题 1-8）"
            }

            CheckBox {
                id: exerciseCheck
                text: "练习册"
                font.pixelSize: Math.round(14 * root.uiScale)
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Math.round(8 * root.uiScale)

                TextField {
                    id: startPage
                    Layout.fillWidth: true
                    font.pixelSize: Math.round(16 * root.uiScale)
                    implicitHeight: Math.round(40 * root.uiScale)
                    placeholderText: "起始页"
                    enabled: exerciseCheck.checked
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                TextField {
                    id: endPage
                    Layout.fillWidth: true
                    font.pixelSize: Math.round(16 * root.uiScale)
                    implicitHeight: Math.round(40 * root.uiScale)
                    placeholderText: "终结页"
                    enabled: exerciseCheck.checked
                    inputMethodHints: Qt.ImhDigitsOnly
                }
            }

            TextArea {
                id: noteArea
                Layout.fillWidth: true
                font.pixelSize: Math.round(15 * root.uiScale)
                Layout.preferredHeight: Math.round(90 * root.uiScale)
                placeholderText: "备注"
            }

            TextField {
                id: tagsField
                Layout.fillWidth: true
                font.pixelSize: Math.round(16 * root.uiScale)
                implicitHeight: Math.round(40 * root.uiScale)
                placeholderText: "标签（用逗号分隔，如：放学前必须交,家长签字）"
            }

            Button {
                text: "添加作业"
                Layout.fillWidth: true
                font.pixelSize: Math.round(16 * root.uiScale)
                implicitHeight: Math.round(42 * root.uiScale)
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
