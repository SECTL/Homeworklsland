import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Flickable {
    id: root
    property var subjectEntries: []
    property real displayScale: 1.0
    property real uiScale: 1.0
    property string appFontFamily: ""
    property color cardColor: "#FFFFFF"
    property color borderColor: "#E1D6C8"
    property color textPrimaryColor: "#3B2E24"
    property color textSecondaryColor: "#5B4A3C"
    clip: true
    contentWidth: width
    contentHeight: flow.implicitHeight * displayScale + Math.round(24 * root.uiScale)

    Flow {
        id: flow
        width: root.width / displayScale
        spacing: Math.round(12 * root.uiScale)
        anchors.margins: Math.round(16 * root.uiScale)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        scale: root.displayScale
        transformOrigin: Item.TopLeft

        Repeater {
            model: root.subjectEntries

            delegate: SubjectCard {
                width: (flow.width - Math.round(16 * root.uiScale) * 2 - Math.round(12 * root.uiScale)) / 2
                subjectName: modelData.name
                modelRef: modelData.model
                uiScale: root.uiScale
                appFontFamily: root.appFontFamily
                cardColor: root.cardColor
                borderColor: root.borderColor
                textPrimaryColor: root.textPrimaryColor
                textSecondaryColor: root.textSecondaryColor
            }
        }
    }
}
