import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: content.implicitHeight + 32
        clip: true

        ColumnLayout {
            id: content

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 24
            spacing: 14

            Image {
                source: "../icon.png"
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 96
                sourceSize.height: 96
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: "HOMEWORKISLAND"
                font.pixelSize: 30
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: "1.2.0.1"
                font.pixelSize: 18
                opacity: 0.8
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Button {
                    text: "打开 GitHub 仓库"
                    onClicked: Qt.openUrlExternally("https://github.com/chenghaolee-2012/Homeworklsland-project")
                }

                Button {
                    text: "QQ群（1046723529）"
                    onClicked: Qt.openUrlExternally("https://qm.qq.com/q/lpxbJ6zRfy")
                }

            }

            Label {
                text: "Copyright 2026 SECTL © all right reserved"
                font.pixelSize: 15
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
            }

        }

    }

}
