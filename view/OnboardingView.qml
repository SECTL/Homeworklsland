import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    property int step: 0
    property string themePreset: "warm"
    property real fontScale: 1
    property real timeScale: 1

    signal themePresetUpdated(string preset)
    signal fontScaleUpdated(real value)
    signal timeScaleUpdated(real value)
    signal finished()

    Rectangle {
        anchors.fill: parent
        color: "#F8F6F2"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        Label {
            text: step === 0 ? "欢迎使用 HomeworkIsland" : (step === 1 ? "外观设置" : "设置完成")
            font.pixelSize: 30
            font.bold: true
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.step

            ColumnLayout {
                spacing: 12

                Label {
                    text: "感谢您选择Homeworklsland!。"
                }

                Label {
                    text: "现在，让我们进行一些设置，然后才能开始使用。"
                }

            }

            ColumnLayout {
                spacing: 12

                Label {
                    text: "主题配色"
                }

                ComboBox {
                    Layout.fillWidth: true
                    model: [{
                        "label": "暖色米白",
                        "value": "warm"
                    }, {
                        "label": "清爽蓝灰",
                        "value": "cool"
                    }, {
                        "label": "墨色深灰",
                        "value": "dark"
                    }]
                    textRole: "label"
                    Component.onCompleted: {
                        for (var i = 0; i < model.length; i++) {
                            if (model[i].value === root.themePreset) {
                                currentIndex = i;
                                break;
                            }
                        }
                    }
                    onCurrentIndexChanged: {
                        if (currentIndex >= 0)
                            root.themePresetUpdated(model[currentIndex].value);

                    }
                }

                Label {
                    text: "字体缩放: " + root.fontScale.toFixed(2) + "x"
                }

                Slider {
                    Layout.fillWidth: true
                    from: 0.8
                    to: 1.8
                    stepSize: 0.05
                    value: root.fontScale
                    onMoved: root.fontScaleUpdated(value)
                }

                Label {
                    text: "时间日期缩放: " + root.timeScale.toFixed(2) + "x"
                }

                Slider {
                    Layout.fillWidth: true
                    from: 0.8
                    to: 2.2
                    stepSize: 0.05
                    value: root.timeScale
                    onMoved: root.timeScaleUpdated(value)
                }

            }

            ColumnLayout {
                spacing: 12

                Label {
                    text: "现在，开始享用全新的作业板吧！。"
                }

                Button {
                    text: "打开项目 GitHub 仓库"
                    onClicked: Qt.openUrlExternally("https://github.com/chenghaolee-2012/Homeworklsland-project")
                }

            }

        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "上一步"
                enabled: root.step > 0
                onClicked: root.step = Math.max(0, root.step - 1)
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: root.step < 2 ? "下一步" : "完成"
                onClicked: {
                    if (root.step < 2)
                        root.step = root.step + 1;
                    else
                        root.finished();
                }
            }

        }

    }

}
