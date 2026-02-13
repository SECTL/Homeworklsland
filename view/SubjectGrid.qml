import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Flickable {
    id: root
    property var subjectEntries: []
    property real displayScale: 1.0
    clip: true
    contentWidth: width
    contentHeight: flow.implicitHeight * displayScale + 24

    Flow {
        id: flow
        width: root.width / displayScale
        spacing: 12
        anchors.margins: 16
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        scale: root.displayScale
        transformOrigin: Item.TopLeft

        Repeater {
            model: root.subjectEntries

            delegate: SubjectCard {
                width: (flow.width - 16 * 2 - 12) / 2
                subjectName: modelData.name
                modelRef: modelData.model
            }
        }
    }
}
