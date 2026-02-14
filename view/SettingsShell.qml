import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    property real displayScale: 1
    property real fontScale: 1
    property real timeScale: 1
    property string themePreset: "warm"
    property string appFontFamily: ""
    property var subjectOptions: []
    property int currentIndex: 0

    signal displayScaleUpdated(real value)
    signal fontScaleUpdated(real value)
    signal timeScaleUpdated(real value)
    signal themePresetUpdated(string preset)
    signal appFontFamilyUpdated(string family)
    signal subjectEnabledUpdated(string name, bool enabled)
    signal subjectAdded(string name)
    signal rerunOnboardingRequested()

    Pane {
        id: sideNav

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 220

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            Pane {
                Layout.fillWidth: true
                padding: 10

                contentItem: Label {
                    text: "作业板设置"
                    font.pixelSize: 18
                    font.bold: true
                }

            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    anchors.fill: parent
                    spacing: 6
                    clip: true
                    model: [{
                        "title": "通用设置",
                        "subtitle": "显示与交互"
                    }, {
                        "title": "学科管理",
                        "subtitle": "启用与新增"
                    }, {
                        "title": "安全",
                        "subtitle": "密码与验证"
                    }, {
                        "title": "个性化",
                        "subtitle": "字体与配色"
                    }, {
                        "title": "其他",
                        "subtitle": "引导与实验"
                    }, {
                        "title": "关于",
                        "subtitle": "应用信息"
                    }]

                    delegate: ItemDelegate {
                        width: parent.width
                        height: 62
                        leftPadding: 14
                        rightPadding: 12
                        highlighted: root.currentIndex === index
                        onClicked: root.currentIndex = index

                        background: Rectangle {
                            radius: 16
                            color: root.currentIndex === index ? Qt.rgba(0.13, 0.59, 0.95, 0.16) : "transparent"
                            border.width: root.currentIndex === index ? 1 : 0
                            border.color: Qt.rgba(0.13, 0.59, 0.95, 0.35)
                        }

                        contentItem: Column {
                            spacing: 2

                            Label {
                                text: modelData.title
                                font.pixelSize: 15
                                font.bold: root.currentIndex === index
                            }

                            Label {
                                text: modelData.subtitle
                                font.pixelSize: 12
                                opacity: 0.75
                            }

                        }

                    }

                }

            }

        }

    }

    Pane {
        anchors.top: parent.top
        anchors.left: sideNav.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            ToolBar {
                Layout.fillWidth: true

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12

                    Label {
                        text: root.currentIndex === 0
                            ? "设置"
                            : (root.currentIndex === 1
                                ? "学科管理"
                                : (root.currentIndex === 2
                                    ? "安全"
                                    : (root.currentIndex === 3
                                        ? "个性化"
                                        : (root.currentIndex === 4 ? "其他" : "关于"))))
                        font.pixelSize: 20
                        font.bold: true
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                }

            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(0, 0, 0, 0.12)
            }

            StackLayout {
                id: pages

                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: root.currentIndex

                SettingsView {
                    displayScale: root.displayScale
                    onDisplayScaleUpdated: root.displayScaleUpdated(value)
                }

                SubjectManagerView {
                    subjectOptions: root.subjectOptions
                    onSubjectEnabledUpdated: root.subjectEnabledUpdated(name, enabled)
                    onSubjectAdded: root.subjectAdded(name)
                }

                SecurityView {
                }

                PersonalizationView {
                    fontScale: root.fontScale
                    timeScale: root.timeScale
                    themePreset: root.themePreset
                    appFontFamily: root.appFontFamily
                    onFontScaleUpdated: root.fontScaleUpdated(value)
                    onTimeScaleUpdated: root.timeScaleUpdated(value)
                    onThemeSelected: root.themePresetUpdated(preset)
                    onAppFontFamilySelected: root.appFontFamilyUpdated(family)
                }

                OtherView {
                    onRerunOnboardingRequested: root.rerunOnboardingRequested()
                }

                AboutView {
                }

            }

        }

    }

}
