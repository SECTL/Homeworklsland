import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    signal rerunOnboardingRequested()

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
                text: "其他"
                font.pixelSize: 22
                font.bold: true
            }

            Label {
                text: "重新进行初次引导"
                font.pixelSize: 15
            }

            Switch {
                id: rerunSwitch
                text: "开启后立即进入引导"
                onToggled: {
                    if (checked) {
                        root.rerunOnboardingRequested()
                        checked = false
                    }
                }
            }

            Label {
                text: "用于重新配置外观和基础设置。"
                wrapMode: Text.Wrap
                opacity: 0.8
            }
        }
    }
}
