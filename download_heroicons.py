#!/usr/bin/env python3
"""
下载 Heroicons 图标库
从 jsdelivr CDN 下载所有 outline 和 solid 图标
"""

import urllib.request
import os
import json

# 图标名称列表（Heroicons 2.2.0 的所有图标）
ICONS = [
    "academic-cap", "adjustments-horizontal", "adjustments-vertical", "archive-box",
    "archive-box-x-mark", "arrow-down", "arrow-down-circle", "arrow-down-left",
    "arrow-down-on-square", "arrow-down-on-square-stack", "arrow-down-right",
    "arrow-down-tray", "arrow-left", "arrow-left-circle", "arrow-left-end-on-rectangle",
    "arrow-left-on-rectangle", "arrow-left-start-on-rectangle", "arrow-long-down",
    "arrow-long-left", "arrow-long-right", "arrow-long-up", "arrow-path",
    "arrow-path-rounded-square", "arrow-right", "arrow-right-circle",
    "arrow-right-end-on-rectangle", "arrow-right-on-rectangle",
    "arrow-right-start-on-rectangle", "arrow-small-down", "arrow-small-left",
    "arrow-small-right", "arrow-small-up", "arrow-top-right-on-square",
    "arrow-trending-down", "arrow-trending-up", "arrow-turn-down-left",
    "arrow-turn-down-right", "arrow-turn-left-down", "arrow-turn-left-up",
    "arrow-turn-right-down", "arrow-turn-right-up", "arrow-turn-up-left",
    "arrow-turn-up-right", "arrow-up", "arrow-up-circle", "arrow-up-left",
    "arrow-up-on-square", "arrow-up-on-square-stack", "arrow-up-right",
    "arrow-up-tray", "arrow-uturn-down", "arrow-uturn-left", "arrow-uturn-right",
    "arrow-uturn-up", "arrows-pointing-in", "arrows-pointing-out",
    "arrows-right-left", "arrows-up-down", "at-symbol", "backspace", "backward",
    "banknotes", "bars-2", "bars-3", "bars-3-bottom-left", "bars-3-bottom-right",
    "bars-3-center-left", "bars-4", "bars-arrow-down", "bars-arrow-up",
    "battery-0", "battery-100", "battery-50", "beaker", "bell", "bell-alert",
    "bell-slash", "bell-snooze", "bold", "bolt", "bolt-slash", "book-open",
    "bookmark", "bookmark-slash", "bookmark-square", "briefcase", "bug-ant",
    "building-library", "building-office", "building-office-2", "building-storefront",
    "cake", "calculator", "calendar", "calendar-date-range", "calendar-days",
    "camera", "chart-bar", "chart-bar-square", "chart-pie", "chat-bubble-bottom-center",
    "chat-bubble-bottom-center-text", "chat-bubble-left", "chat-bubble-left-ellipsis",
    "chat-bubble-left-right", "chat-bubble-oval-left", "chat-bubble-oval-left-ellipsis",
    "check", "check-badge", "check-circle", "chevron-double-down",
    "chevron-double-left", "chevron-double-right", "chevron-double-up",
    "chevron-down", "chevron-left", "chevron-right", "chevron-up",
    "chevron-up-down", "circle-stack", "clipboard", "clipboard-document",
    "clipboard-document-check", "clipboard-document-list", "clock", "cloud",
    "cloud-arrow-down", "cloud-arrow-up", "code-bracket", "code-bracket-square",
    "cog", "cog-6-tooth", "cog-8-tooth", "command-line", "computer-desktop",
    "cpu-chip", "credit-card", "cube", "cube-transparent", "currency-bangladeshi",
    "currency-dollar", "currency-euro", "currency-pound", "currency-rupee",
    "currency-yen", "cursor-arrow-rays", "cursor-arrow-ripple",
    "device-phone-mobile", "device-tablet", "divide", "document",
    "document-arrow-down", "document-arrow-up", "document-chart-bar",
    "document-check", "document-currency-bangladeshi", "document-currency-dollar",
    "document-currency-euro", "document-currency-pound", "document-currency-rupee",
    "document-currency-yen", "document-duplicate", "document-magnifying-glass",
    "document-minus", "document-plus", "document-text", "ellipsis-horizontal",
    "ellipsis-horizontal-circle", "ellipsis-vertical", "envelope",
    "envelope-open", "equals", "exclamation-circle", "exclamation-triangle",
    "eye", "eye-dropper", "eye-slash", "face-frown", "face-smile",
    "film", "finger-print", "fire", "flag", "folder", "folder-arrow-down",
    "folder-minus", "folder-open", "folder-plus", "forward", "funnel",
    "gif", "gift", "gift-top", "globe-alt", "globe-americas",
    "globe-asia-australia", "globe-europe-africa", "h1", "h2", "h3",
    "hand-raised", "hand-thumb-down", "hand-thumb-up", "hashtag", "heart",
    "home", "home-modern", "identification", "inbox", "inbox-arrow-down",
    "inbox-stack", "information-circle", "italic", "key", "language",
    "lifebuoy", "light-bulb", "link", "link-slash", "list-bullet",
    "lock-closed", "lock-open", "magnifying-glass", "magnifying-glass-circle",
    "magnifying-glass-minus", "magnifying-glass-plus", "map", "map-pin",
    "megaphone", "microphone", "minus", "minus-circle", "minus-small",
    "moon", "musical-note", "newspaper", "no-symbol", "numbered-list",
    "paint-brush", "paper-airplane", "paper-clip", "pause", "pause-circle",
    "pencil", "pencil-square", "percent-badge", "phone", "phone-arrow-down-left",
    "phone-arrow-up-right", "phone-x-mark", "photo", "play", "play-circle",
    "play-pause", "plus", "plus-circle", "plus-small", "power", "presentation-chart-bar",
    "presentation-chart-line", "printer", "puzzle-piece", "qr-code",
    "question-mark-circle", "queue-list", "radio", "receipt-percent",
    "receipt-refund", "rectangle-group", "rectangle-stack", "rocket-launch",
    "rss", "scale", "scissors", "server", "server-stack", "share",
    "shield-check", "shield-exclamation", "shopping-bag", "shopping-cart",
    "signal", "signal-slash", "slash", "sparkles", "speaker-wave",
    "speaker-x-mark", "square-2-stack", "square-3-stack-3d", "squares-2x2",
    "squares-plus", "star", "stop", "stop-circle", "sun", "swatch",
    "table-cells", "tag", "ticket", "trash", "trophy", "truck",
    "tv", "underline", "user", "user-circle", "user-group", "user-minus",
    "user-plus", "users", "variable", "video-camera", "video-camera-slash",
    "view-columns", "viewfinder-circle", "wallet", "wifi", "window",
    "wrench", "wrench-screwdriver", "x-circle", "x-mark"
]

def download_icon(icon_name, style, size="24"):
    """下载单个图标"""
    url = f"https://cdn.jsdelivr.net/npm/heroicons@2.2.0/{size}/{style}/{icon_name}.svg"
    output_dir = f"/Users/lijf/Documents/assignsticker-verge/icons/heroicons/{size}/{style}"
    output_path = os.path.join(output_dir, f"{icon_name}.svg")

    try:
        urllib.request.urlretrieve(url, output_path)
        return True
    except Exception as e:
        print(f"  错误: {icon_name} - {e}")
        return False

def main():
    print("开始下载 Heroicons 图标库...")
    print(f"共 {len(ICONS)} 个图标")
    print()

    # 下载 outline 风格（线性图标）
    print("下载 24/outline (线性图标)...")
    outline_success = 0
    for i, icon in enumerate(ICONS, 1):
        if download_icon(icon, "outline"):
            outline_success += 1
        if i % 50 == 0:
            print(f"  进度: {i}/{len(ICONS)}")
    print(f"  完成: {outline_success}/{len(ICONS)} 个图标")
    print()

    # 下载 solid 风格（填充图标）
    print("下载 24/solid (填充图标)...")
    solid_success = 0
    for i, icon in enumerate(ICONS, 1):
        if download_icon(icon, "solid"):
            solid_success += 1
        if i % 50 == 0:
            print(f"  进度: {i}/{len(ICONS)}")
    print(f"  完成: {solid_success}/{len(ICONS)} 个图标")
    print()

    # 创建索引文件
    index_data = {
        "name": "Heroicons",
        "version": "2.2.0",
        "license": "MIT",
        "source": "https://heroicons.com",
        "total_icons": len(ICONS),
        "styles": ["outline", "solid"],
        "sizes": ["24"],
        "icons": ICONS
    }

    index_path = "/Users/lijf/Documents/assignsticker-verge/icons/heroicons/index.json"
    with open(index_path, 'w', encoding='utf-8') as f:
        json.dump(index_data, f, indent=2, ensure_ascii=False)

    print(f"图标库索引已保存到: {index_path}")
    print()
    print("下载完成!")
    print(f"  - 线性图标 (outline): {outline_success} 个")
    print(f"  - 填充图标 (solid): {solid_success} 个")
    print(f"  - 总计: {outline_success + solid_success} 个 SVG 文件")

if __name__ == "__main__":
    main()
