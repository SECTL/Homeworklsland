import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    property real displayScale: 1

    signal displayScaleUpdated(real value)

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: content.implicitHeight + 24
        clip: true

        ColumnLayout {
            id: content

            anchors.margins: 16
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 12

            Label {
                text: "通用设置"
                font.pixelSize: 20
            }

            Label {
                text: "作业显示缩放"
            }

            Slider {
                id: scaleSlider

                from: 0.8
                to: 1.6
                stepSize: 0.05
                value: root.displayScale
                Layout.fillWidth: true
                onValueChanged: root.displayScaleUpdated(value)
            }

            Label {
                text: "当前缩放: " + scaleSlider.value.toFixed(2) + " 倍"
                font.pixelSize: 12
                color: "#6C5B4C"
            }

            Switch {
                text: "紧凑模式"
            }

            Switch {
                text: "始终置顶"
            }

            Switch {
                text: "自动收纳"
            }

        }

    }

}
