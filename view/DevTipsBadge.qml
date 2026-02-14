import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root
    property bool enabled: false
    property real uiScale: 1.0

    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.leftMargin: Math.round(12 * uiScale)
    anchors.bottomMargin: Math.round(10 * uiScale)
    visible: enabled
    z: 999

    Rectangle {
        radius: Math.round(8 * root.uiScale)
        color: "#AA202020"
        border.color: "#99FFFFFF"
        border.width: 1
        anchors.fill: tipText
        anchors.margins: -Math.round(8 * root.uiScale)
    }

    Text {
        id: tipText
        text: "开发中版本，不代表最终效果\\n1.2.0.2-Arc de Triomphe-debug"
        color: "#FFFFFF"
        font.pixelSize: Math.round(12 * root.uiScale)
        wrapMode: Text.WordWrap
    }
}
