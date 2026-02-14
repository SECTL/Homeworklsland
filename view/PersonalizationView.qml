import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    property real fontScale: 1.0
    property real timeScale: 1.0
    property string themePreset: "warm"
    property string appFontFamily: ""
    property var systemFonts: []

    signal fontScaleUpdated(real value)
    signal timeScaleUpdated(real value)
    signal themeSelected(string preset)
    signal appFontFamilySelected(string family)

    function loadFonts() {
        if (typeof saveService === "undefined" || !saveService) {
            systemFonts = []
            return
        }
        var raw = saveService.systemFontFamilies()
        var parsed = []
        try {
            parsed = JSON.parse(raw)
        } catch (e) {
            parsed = []
        }
        systemFonts = parsed
        var current = appFontFamily
        updateFontIndex(current)
    }

    function updateFontIndex(family) {
        for (var i = 0; i < fontCombo.model.length; i++) {
            if (fontCombo.model[i] === family) {
                fontCombo.currentIndex = i
                return
            }
        }
    }

    Component.onCompleted: loadFonts()
    onAppFontFamilyChanged: updateFontIndex(appFontFamily)

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
                text: "个性化"
                font.pixelSize: 22
                font.bold: true
            }

            Label { text: "程序全局字体" }
            ComboBox {
                id: fontCombo
                Layout.fillWidth: true
                model: root.systemFonts
                enabled: model.length > 0
                onActivated: {
                    if (currentIndex >= 0 && model[currentIndex]) {
                        root.appFontFamily = model[currentIndex]
                        root.appFontFamilySelected(model[currentIndex])
                    }
                }
            }
            Label {
                text: "当前字体: " + (root.appFontFamily.length > 0 ? root.appFontFamily : "默认")
                font.pixelSize: 12
                opacity: 0.8
            }

            Label { text: "程序字体缩放" }
            Slider {
                from: 0.8
                to: 1.8
                stepSize: 0.05
                value: root.fontScale
                Layout.fillWidth: true
                onMoved: root.fontScaleUpdated(value)
            }
            Label {
                text: "当前字体缩放: " + root.fontScale.toFixed(2) + " 倍"
                font.pixelSize: 12
                opacity: 0.8
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(0, 0, 0, 0.12)
            }

            Label { text: "时间日期显示缩放" }
            Slider {
                from: 0.8
                to: 2.2
                stepSize: 0.05
                value: root.timeScale
                Layout.fillWidth: true
                onMoved: root.timeScaleUpdated(value)
            }
            Label {
                text: "当前时间缩放: " + root.timeScale.toFixed(2) + " 倍"
                font.pixelSize: 12
                opacity: 0.8
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(0, 0, 0, 0.12)
            }

            Label { text: "外观配色" }
            ComboBox {
                Layout.fillWidth: true
                model: [
                    { label: "暖色米白", value: "warm" },
                    { label: "清爽蓝灰", value: "cool" },
                    { label: "墨色深灰", value: "dark" }
                ]
                textRole: "label"

                Component.onCompleted: {
                    for (var i = 0; i < model.length; i++) {
                        if (model[i].value === root.themePreset) {
                            currentIndex = i
                            break
                        }
                    }
                }

                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        root.themeSelected(model[currentIndex].value)
                    }
                }
            }
        }
    }
}
