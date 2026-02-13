import json
import os
import sys
import hashlib
import hmac
from datetime import date, datetime

from PyQt5 import QtCore, QtGui
from PyQt5.QtCore import QProcess, QObject, pyqtSlot
from PyQt5.QtGui import QIcon, QPixmap, QPainter
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication, QSystemTrayIcon, QMenu, QAction, QInputDialog, QLineEdit, QMessageBox


class SaveService(QObject):
    def __init__(self, base_dir: str) -> None:
        super().__init__()
        self._base_dir = base_dir
        self._saves_dir = os.path.join(base_dir, "saves")
        self._config_file = os.path.join(self._saves_dir, "config.json")
        os.makedirs(self._saves_dir, exist_ok=True)

    def _today_str(self) -> str:
        return date.today().isoformat()

    def _today_file(self) -> str:
        return os.path.join(self._saves_dir, f"{self._today_str()}.json")

    @pyqtSlot(result=str)
    def currentDay(self) -> str:
        return self._today_str()

    def _load_config(self) -> dict:
        if not os.path.exists(self._config_file):
            return {}
        try:
            with open(self._config_file, "r", encoding="utf-8") as f:
                data = json.load(f)
            return data if isinstance(data, dict) else {}
        except (OSError, json.JSONDecodeError):
            return {}

    def _save_config(self, cfg: dict) -> bool:
        tmp = self._config_file + ".tmp"
        try:
            with open(tmp, "w", encoding="utf-8") as f:
                json.dump(cfg, f, ensure_ascii=False, indent=2)
            os.replace(tmp, self._config_file)
            return True
        except OSError:
            return False

    def _hash_password(self, pwd: str) -> str:
        return hashlib.sha256(pwd.encode("utf-8")).hexdigest()

    @pyqtSlot(result=bool)
    def hasPassword(self) -> bool:
        cfg = self._load_config()
        p = cfg.get("passwordHash", "")
        return isinstance(p, str) and len(p) > 0

    @pyqtSlot(str, result=bool)
    def setPassword(self, password: str) -> bool:
        clean = (password or "").strip()
        if len(clean) == 0:
            return False
        cfg = self._load_config()
        cfg["passwordHash"] = self._hash_password(clean)
        cfg["passwordUpdatedAt"] = datetime.now().isoformat(timespec="seconds")
        return self._save_config(cfg)

    @pyqtSlot(str, result=bool)
    def verifyPassword(self, password: str) -> bool:
        cfg = self._load_config()
        expected = cfg.get("passwordHash", "")
        if not isinstance(expected, str) or len(expected) == 0:
            return True
        actual = self._hash_password(password or "")
        return hmac.compare_digest(expected, actual)

    @pyqtSlot(result=str)
    def loadAboutHtml(self) -> str:
        html_path = os.path.join(self._base_dir, "about.html")
        if not os.path.exists(html_path):
            return "<html><body><h3>about.html 不存在</h3></body></html>"
        try:
            with open(html_path, "r", encoding="utf-8") as f:
                html = f.read()
        except OSError:
            return "<html><body><h3>about.html 读取失败</h3></body></html>"

        bg_style = (
            "<style>"
            "body{background:#F8F6F2 !important;margin:16px;"
            "font-family:'PingFang SC','Helvetica Neue',Arial,sans-serif;color:#2F2F2F;}"
            "</style>"
        )

        if "</head>" in html:
            return html.replace("</head>", bg_style + "</head>", 1)
        return "<html><head>" + bg_style + "</head><body>" + html + "</body></html>"

    @pyqtSlot(result=str)
    def loadToday(self) -> str:
        file_path = self._today_file()
        if not os.path.exists(file_path):
            return "{}"
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                payload = json.load(f)
            if not isinstance(payload, dict):
                return "{}"
            return json.dumps(payload, ensure_ascii=False)
        except (OSError, json.JSONDecodeError):
            return "{}"

    @pyqtSlot(str, result=bool)
    def saveToday(self, payload_json: str) -> bool:
        try:
            payload = json.loads(payload_json) if payload_json else {}
            if not isinstance(payload, dict):
                payload = {}
        except json.JSONDecodeError:
            return False

        payload["date"] = self._today_str()
        payload["savedAt"] = datetime.now().isoformat(timespec="seconds")
        file_path = self._today_file()
        temp_path = file_path + ".tmp"

        try:
            with open(temp_path, "w", encoding="utf-8") as f:
                json.dump(payload, f, ensure_ascii=False, indent=2)
            os.replace(temp_path, file_path)
            return True
        except OSError:
            return False


def main() -> int:
    # Use Material style (Qt Quick Controls 2)
    os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Material")
    os.environ.setdefault("QT_QUICK_CONTROLS_MATERIAL_THEME", "Light")
    os.environ.setdefault("QT_QUICK_CONTROLS_MATERIAL_VARIANT", "Dense")

    app = QApplication(sys.argv)
    app.setOrganizationName("HOMEWORKISLAND")
    app.setApplicationName("SECTL-HOMEWORKISLAND")
    app.setQuitOnLastWindowClosed(False)

    project_dir = os.path.dirname(__file__)
    save_service = SaveService(project_dir)

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("saveService", save_service)
    qml_path = os.path.join(project_dir, "qml", "Main.qml")
    engine.load(QtCore.QUrl.fromLocalFile(qml_path))

    if not engine.rootObjects():
        return 1

    root = engine.rootObjects()[0]
    mini_window = root.findChild(QtCore.QObject, "miniWindow")
    settings_window = root.findChild(QtCore.QObject, "settingsWindow")

    def require_password_dialog() -> bool:
        if not save_service.hasPassword():
            return True
        text, ok = QInputDialog.getText(
            None,
            "身份验证",
            "请输入密码：",
            QLineEdit.Password,
        )
        if not ok:
            return False
        if save_service.verifyPassword(text):
            return True
        QMessageBox.warning(None, "验证失败", "密码错误。")
        return False

    def build_tray_icon() -> QIcon:
        icon = QIcon.fromTheme("view-calendar")
        if not icon.isNull():
            return icon
        pixmap = QPixmap(64, 64)
        pixmap.fill(QtGui.QColor("#E3C79E"))
        painter = QPainter(pixmap)
        painter.setPen(QtGui.QColor("#3B2E24"))
        painter.setFont(QtGui.QFont("Sans Serif", 20, QtGui.QFont.Bold))
        painter.drawText(pixmap.rect(), QtCore.Qt.AlignCenter, "作")
        painter.end()
        return QIcon(pixmap)

    tray = QSystemTrayIcon(build_tray_icon(), app)
    tray.setToolTip("作业板")

    menu = QMenu()

    def toggle_mini_widget() -> None:
        if mini_window is None:
            return
        visible = mini_window.property("visible")
        mini_window.setProperty("visible", not bool(visible))

    def show_settings() -> None:
        if not require_password_dialog():
            return
        if settings_window is None:
            return
        settings_window.setProperty("visible", True)
        settings_window.setProperty("windowState", QtCore.Qt.WindowActive)

    def restart_app() -> None:
        if not require_password_dialog():
            return
        QProcess.startDetached(sys.executable, sys.argv)
        app.quit()

    action_toggle = QAction("显示/隐藏小组件", menu)
    action_toggle.triggered.connect(toggle_mini_widget)
    menu.addAction(action_toggle)

    action_settings = QAction("打卡设置窗口", menu)
    action_settings.triggered.connect(show_settings)
    menu.addAction(action_settings)

    action_restart = QAction("重启", menu)
    action_restart.triggered.connect(restart_app)
    menu.addAction(action_restart)

    action_quit = QAction("退出", menu)
    action_quit.triggered.connect(lambda: app.quit() if require_password_dialog() else None)
    menu.addAction(action_quit)

    tray.setContextMenu(menu)
    tray.show()

    return app.exec_()


if __name__ == "__main__":
    sys.exit(main())
