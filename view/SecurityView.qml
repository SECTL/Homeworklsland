import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

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
                text: "安全设置"
                font.pixelSize: 22
                font.bold: true
            }

            Label {
                text: "设置密码后，打开设置窗口、退出、重启都需要验证。"
                wrapMode: Text.Wrap
                opacity: 0.8
            }

            Label {
                id: statusLabel
                text: (typeof saveService !== "undefined" && saveService && saveService.hasPassword())
                    ? "当前状态：已设置密码"
                    : "当前状态：未设置密码"
                color: "#5F6A6A"
            }

            TextField {
                id: pwd1
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "输入新密码"
            }

            TextField {
                id: pwd2
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "再次输入新密码"
            }

            Label {
                id: messageLabel
                text: ""
                color: "#B03A2E"
                visible: text.length > 0
            }

            Button {
                text: "保存密码"
                Layout.fillWidth: true
                onClicked: {
                    var a = pwd1.text
                    var b = pwd2.text
                    if (a.length === 0) {
                        messageLabel.text = "密码不能为空"
                        return
                    }
                    if (a !== b) {
                        messageLabel.text = "两次输入不一致"
                        return
                    }
                    if (typeof saveService === "undefined" || !saveService) {
                        messageLabel.text = "后端服务不可用"
                        return
                    }
                    var ok = saveService.setPassword(a)
                    if (!ok) {
                        messageLabel.text = "保存失败"
                        return
                    }
                    pwd1.text = ""
                    pwd2.text = ""
                    messageLabel.color = "#1E8449"
                    messageLabel.text = "密码已保存"
                    statusLabel.text = "当前状态：已设置密码"
                }
            }
        }
    }
}
