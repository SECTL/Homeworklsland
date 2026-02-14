import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import "../view" as View

Item {
    id: appRoot

    property bool boardVisible: true
    property bool fullScreen: false
    property real displayScale: 1.2
    property real uiScale: {
        var g = (boardWindow && boardWindow.avail) ? boardWindow.avail : Qt.rect(0, 0, 1920, 1080)
        var s = Math.min(g.width / 1920.0, g.height / 1080.0)
        return Math.max(0.75, Math.min(1.35, s))
    }
    property var visibleSubjectEntries: []
    property int subjectsVersion: 0
    property string activeDay: ""
    signal showBoard()
    signal hideBoard()
    signal showSettings()
    property string pendingProtectedAction: ""

    function scaled(px) {
        return Math.round(px * uiScale)
    }

    function boardDefaultWidth(g) {
        return Math.round(Math.max(900, Math.min(2165, g.width * 0.96)))
    }

    function boardDefaultHeight(g) {
        return Math.round(Math.max(640, Math.min(1233, g.height * 0.96)))
    }

    function settingsDefaultWidth(g) {
        return Math.round(Math.max(860, Math.min(1265, g.width * 0.94)))
    }

    function settingsDefaultHeight(g) {
        return Math.round(Math.max(620, Math.min(863, g.height * 0.92)))
    }

    function addAssignment(subject, title, isExercise, startPage, endPage, note, tags) {
        if (!subject || subject.length === 0) {
            return
        }
        var detail = ""
        if (isExercise) {
            if (startPage > 0 && endPage > 0) {
                detail = "练习册 页码 " + startPage + " - " + endPage
            } else if (startPage > 0) {
                detail = "练习册 从第 " + startPage + " 页"
            } else {
                detail = "练习册"
            }
        }
        var tagsText = tags
        var model = subjectModels[subject]
        if (!model) {
            return
        }
        model.append({
            title: title,
            detail: detail,
            note: note,
            tags: tagsText
        })
        saveTodayState()
    }

    ListModel { id: modelChinese }
    ListModel { id: modelEnglish }
    ListModel { id: modelMath }
    ListModel { id: modelGeography }
    ListModel { id: modelBiology }
    ListModel { id: modelMorality }
    ListModel { id: modelPhysics }
    ListModel { id: modelHistory }
    ListModel { id: modelPolitics }

    property var subjectEntries: [
        { name: "语文", model: modelChinese, enabled: true },
        { name: "英语", model: modelEnglish, enabled: true },
        { name: "数学", model: modelMath, enabled: true },
        { name: "地理", model: modelGeography, enabled: true },
        { name: "生物", model: modelBiology, enabled: true },
        { name: "道德与法治", model: modelMorality, enabled: true },
        { name: "物理", model: modelPhysics, enabled: true },
        { name: "历史", model: modelHistory, enabled: true },
        { name: "政治", model: modelPolitics, enabled: true }
    ]

    property var subjectModels: ({
        "语文": modelChinese,
        "英语": modelEnglish,
        "数学": modelMath,
        "地理": modelGeography,
        "生物": modelBiology,
        "道德与法治": modelMorality,
        "物理": modelPhysics,
        "历史": modelHistory,
        "政治": modelPolitics
    })

    function refreshVisibleSubjects() {
        var list = []
        for (var i = 0; i < subjectEntries.length; i++) {
            if (subjectEntries[i].enabled) {
                list.push(subjectEntries[i])
            }
        }
        visibleSubjectEntries = list
        subjectsVersion = subjectsVersion + 1
    }

    function getSubjectOptions() {
        var list = []
        for (var i = 0; i < subjectEntries.length; i++) {
            list.push({ name: subjectEntries[i].name, enabled: subjectEntries[i].enabled })
        }
        return list
    }

    function getEnabledSubjectNames() {
        var list = []
        for (var i = 0; i < subjectEntries.length; i++) {
            if (subjectEntries[i].enabled) {
                list.push(subjectEntries[i].name)
            }
        }
        return list
    }

    function setSubjectEnabled(name, enabled) {
        for (var i = 0; i < subjectEntries.length; i++) {
            if (subjectEntries[i].name === name) {
                subjectEntries[i].enabled = enabled
                break
            }
        }
        refreshVisibleSubjects()
        saveTodayState()
    }

    function addSubject(name) {
        var cleanName = name ? name.trim() : ""
        if (cleanName.length === 0) {
            return false
        }
        for (var i = 0; i < subjectEntries.length; i++) {
            if (subjectEntries[i].name === cleanName) {
                return false
            }
        }
        var model = Qt.createQmlObject("import QtQuick 2.12; ListModel {}", appRoot, "subjectModel_" + cleanName)
        subjectModels[cleanName] = model
        subjectEntries.push({ name: cleanName, model: model, enabled: true })
        refreshVisibleSubjects()
        saveTodayState()
        return true
    }

    function clearAllAssignments() {
        for (var i = 0; i < subjectEntries.length; i++) {
            subjectEntries[i].model.clear()
        }
    }

    function ensureSubject(name, enabled) {
        for (var i = 0; i < subjectEntries.length; i++) {
            if (subjectEntries[i].name === name) {
                subjectEntries[i].enabled = enabled
                return
            }
        }
        var model = Qt.createQmlObject("import QtQuick 2.12; ListModel {}", appRoot, "subjectModel_" + name)
        subjectModels[name] = model
        subjectEntries.push({ name: name, model: model, enabled: enabled })
    }

    function collectTodayState() {
        var subjects = []
        var assignments = {}
        for (var i = 0; i < subjectEntries.length; i++) {
            var entry = subjectEntries[i]
            subjects.push({ name: entry.name, enabled: entry.enabled })
            assignments[entry.name] = []
            for (var j = 0; j < entry.model.count; j++) {
                assignments[entry.name].push(entry.model.get(j))
            }
        }
        return { subjects: subjects, assignments: assignments }
    }

    function saveTodayState() {
        if (typeof saveService === "undefined" || !saveService) {
            return
        }
        saveService.saveToday(JSON.stringify(collectTodayState()))
    }

    function currentDayValue() {
        if (typeof saveService === "undefined" || !saveService) {
            return ""
        }
        return saveService.currentDay()
    }

    function loadTodayState() {
        if (typeof saveService === "undefined" || !saveService) {
            activeDay = ""
            refreshVisibleSubjects()
            return
        }
        var raw = saveService.loadToday()
        if (!raw || raw.length === 0 || raw === "{}") {
            activeDay = currentDayValue()
            refreshVisibleSubjects()
            return
        }
        var data = {}
        try {
            data = JSON.parse(raw)
        } catch (e) {
            activeDay = currentDayValue()
            refreshVisibleSubjects()
            return
        }
        clearAllAssignments()
        if (data.subjects && data.subjects.length) {
            for (var i = 0; i < data.subjects.length; i++) {
                var s = data.subjects[i]
                ensureSubject(s.name, s.enabled !== false)
            }
        }
        if (data.assignments) {
            for (var key in data.assignments) {
                if (!subjectModels[key]) {
                    ensureSubject(key, true)
                }
                var list = data.assignments[key]
                var model = subjectModels[key]
                for (var n = 0; n < list.length; n++) {
                    model.append(list[n])
                }
            }
        }
        activeDay = currentDayValue()
        refreshVisibleSubjects()
    }

    function performProtectedAction(action) {
        if (action === "settings") {
            showSettings()
            return
        }
        if (action === "exit") {
            Qt.quit()
            return
        }
    }

    function requestProtectedAction(action) {
        if (typeof saveService === "undefined" || !saveService || !saveService.hasPassword()) {
            performProtectedAction(action)
            return
        }
        pendingProtectedAction = action
        passwordField.text = ""
        authErrorLabel.text = ""
        authPopup.open()
    }

    function handleDayRollover() {
        var nowDay = currentDayValue()
        if (nowDay.length === 0) {
            return
        }
        if (activeDay.length === 0) {
            activeDay = nowDay
            return
        }
        if (nowDay !== activeDay) {
            activeDay = nowDay
            clearAllAssignments()
            refreshVisibleSubjects()
            saveTodayState()
        }
    }

    Component.onCompleted: {
        refreshVisibleSubjects()
        loadTodayState()
    }

    Timer {
        interval: 5 * 60 * 1000
        running: true
        repeat: true
        onTriggered: saveTodayState()
    }

    Timer {
        interval: 60 * 1000
        running: true
        repeat: true
        onTriggered: handleDayRollover()
    }

    Window {
        id: boardWindow
        readonly property var avail: (screen && screen.availableGeometry) ? screen.availableGeometry : Qt.rect(0, 0, 1920, 1080)
        objectName: "boardWindow"
        property bool startupPositioned: false
        width: appRoot.boardDefaultWidth(avail)
        height: appRoot.boardDefaultHeight(avail)
        color: "#F8F6F2"
        flags: Qt.FramelessWindowHint | Qt.Window
        visible: true

        property int compactMargin: 16

        onVisibleChanged: {
            if (visible) {
                appRoot.boardVisible = true
            }
        }

        function updatePosition() {
            var g = avail
            x = g.x + (g.width - width) / 2
            y = appRoot.boardVisible
                ? g.y + (g.height - height) / 2
                : g.y + g.height
        }

        Component.onCompleted: {
            appRoot.boardVisible = true
            applyFullscreen()
            updatePosition()
            startupPositioned = true
        }

        onWidthChanged: updatePosition()
        onHeightChanged: updatePosition()
        onScreenChanged: {
            if (!appRoot.fullScreen) {
                width = appRoot.boardDefaultWidth(avail)
                height = appRoot.boardDefaultHeight(avail)
            }
            updatePosition()
        }

        Behavior on y {
            enabled: startupPositioned
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        onClosing: {
            appRoot.boardVisible = false
            close.accepted = false
        }

        function applyFullscreen() {
            if (appRoot.fullScreen) {
                visibility = Window.FullScreen
            } else {
                visibility = Window.Windowed
                width = appRoot.boardDefaultWidth(avail)
                height = appRoot.boardDefaultHeight(avail)
            }
        }

        Connections {
            target: appRoot
            function onShowBoard() {
                boardWindow.visible = true
                appRoot.boardVisible = true
                boardWindow.updatePosition()
                boardWindow.raise()
                boardWindow.requestActivate()
            }
            function onHideBoard() {
                appRoot.boardVisible = false
                boardWindow.visible = false
                boardWindow.updatePosition()
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "#F8F6F2"

            View.BoardView {
                id: boardView
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                uiScale: appRoot.uiScale
                subjectEntries: appRoot.visibleSubjectEntries
            }

            View.SubjectGrid {
                id: subjectGrid
                anchors {
                    top: boardView.bottom
                    left: parent.left
                    right: parent.right
                    bottom: bottomBar.top
                }
                subjectEntries: appRoot.visibleSubjectEntries
                displayScale: appRoot.displayScale
                uiScale: appRoot.uiScale
            }

            Popup {
                id: assignPopup
                modal: true
                focus: true
                dim: true
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                anchors.centerIn: parent
                width: Math.min(parent.width * 0.95, 680)
                height: Math.min(parent.height * 0.85, 720)

                background: Rectangle {
                    radius: 16
                    color: "#FFFFFF"
                    border.color: "#E1D6C8"
                    border.width: 1
                }

                View.AssignView {
                    anchors.fill: parent
                    uiScale: appRoot.uiScale
                    subjectNames: {
                        appRoot.subjectsVersion
                        return appRoot.getEnabledSubjectNames()
                    }
                    onSubmitAssignment: {
                        appRoot.addAssignment(subject, title, isExercise, startPage, endPage, note, tags)
                        assignPopup.close()
                    }
                }
            }

            View.BottomBar {
                id: bottomBar
                uiScale: appRoot.uiScale
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onRequestAssign: assignPopup.open()
                onRequestSettings: appRoot.requestProtectedAction("settings")
                onToggleFullscreen: {
                    appRoot.fullScreen = !appRoot.fullScreen
                    boardWindow.applyFullscreen()
                }
                onRequestExit: appRoot.requestProtectedAction("exit")
                onRequestHide: appRoot.hideBoard()
            }

            Popup {
                id: authPopup
                modal: true
                focus: true
                dim: true
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                anchors.centerIn: parent
                width: 360
                height: appRoot.scaled(220)

                background: Rectangle {
                    radius: 14
                    color: "#FFFFFF"
                    border.color: "#D9D9D9"
                    border.width: 1
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: appRoot.scaled(16)
                    spacing: appRoot.scaled(10)

                    Label {
                        text: "请输入密码"
                        font.pixelSize: appRoot.scaled(18)
                        font.bold: true
                    }

                    TextField {
                        id: passwordField
                        Layout.fillWidth: true
                        echoMode: TextInput.Password
                        placeholderText: "密码"
                    }

                    Label {
                        id: authErrorLabel
                        text: ""
                        color: "#B03A2E"
                        visible: text.length > 0
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Item { Layout.fillWidth: true }
                        Button {
                            text: "取消"
                            onClicked: authPopup.close()
                        }
                        Button {
                            text: "确认"
                            onClicked: {
                                if (typeof saveService === "undefined" || !saveService) {
                                    authErrorLabel.text = "后端服务不可用"
                                    return
                                }
                                if (!saveService.verifyPassword(passwordField.text)) {
                                    authErrorLabel.text = "密码错误"
                                    return
                                }
                                var action = pendingProtectedAction
                                authPopup.close()
                                performProtectedAction(action)
                            }
                        }
                    }
                }
            }

        }
    }

    Window {
        id: miniWindow
        objectName: "miniWindow"
        readonly property var avail: (screen && screen.availableGeometry) ? screen.availableGeometry : Qt.rect(0, 0, 1920, 1080)
        width: appRoot.scaled(88)
        height: appRoot.scaled(88)
        flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
        color: "transparent"
        visible: !appRoot.boardVisible

        x: avail.x + avail.width - width - 24
        y: avail.y + avail.height / 2 - height / 2

        View.MiniWidget {
            anchors.fill: parent
            onOpenRequested: appRoot.showBoard()
        }
    }

    Window {
        id: settingsWindow
        objectName: "settingsWindow"
        readonly property var avail: (screen && screen.availableGeometry) ? screen.availableGeometry : Qt.rect(0, 0, 1920, 1080)
        width: appRoot.settingsDefaultWidth(avail)
        height: appRoot.settingsDefaultHeight(avail)
        minimumWidth: 760
        minimumHeight: 520
        maximumWidth: avail.width
        maximumHeight: avail.height
        visible: false
        color: "#F8F6F2"
        flags: Qt.Window | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint
        title: "设置"

        x: Math.max(avail.x, avail.x + avail.width - width - 24)
        y: Math.max(avail.y, avail.y + 48)

        Connections {
            target: appRoot
            function onShowSettings() {
                settingsWindow.width = appRoot.settingsDefaultWidth(settingsWindow.avail)
                settingsWindow.height = appRoot.settingsDefaultHeight(settingsWindow.avail)
                settingsWindow.visible = true
                settingsWindow.raise()
                settingsWindow.requestActivate()
            }
        }

        View.SettingsShell {
            anchors.fill: parent
            displayScale: appRoot.displayScale
            subjectOptions: {
                appRoot.subjectsVersion
                return appRoot.getSubjectOptions()
            }
            onDisplayScaleUpdated: appRoot.displayScale = value
            onSubjectEnabledUpdated: appRoot.setSubjectEnabled(name, enabled)
            onSubjectAdded: appRoot.addSubject(name)
        }
    }

    Window {
        id: splashWindow
        objectName: "splashWindow"
        readonly property var avail: (screen && screen.availableGeometry) ? screen.availableGeometry : Qt.rect(0, 0, 1920, 1080)
        width: appRoot.boardDefaultWidth(avail)
        height: appRoot.boardDefaultHeight(avail)
        visible: true
        color: "#FFFFFF"
        flags: Qt.Window
        title: "空白窗口"

        x: avail.x + (avail.width - width) / 2
        y: Math.max(avail.y, avail.y + (avail.height - height) / 2)

        Item { anchors.fill: parent }
    }
}
