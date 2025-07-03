import Cocoa
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {

        func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 请求通知权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }

        // 检查命令行参数，判断是否为工具栏模式
        let arguments = CommandLine.arguments
        if arguments.contains("--toolbar-mode") {
            handleToolbarMode()
            return
        }

        // 改进的工具栏模式检测
        if isLikelyFromToolbar() {
            handleToolbarMode()
            return
        }

        showInstallationDialog()
    }

    private func isLikelyFromToolbar() -> Bool {
        // 检查多个条件来判断是否从工具栏点击
        let workspace = NSWorkspace.shared

        // 1. 检查前台应用是否是Finder
        guard let frontmostApp = workspace.frontmostApplication,
              frontmostApp.bundleIdentifier == "com.apple.finder" else {
            return false
        }

        // 2. 检查应用启动方式 - 如果没有显示安装界面的历史记录，更可能是工具栏点击
        let hasShownInstallDialog = UserDefaults.standard.bool(forKey: "HasShownInstallDialog")
        if hasShownInstallDialog {
            return true
        }

        // 3. 检查是否有活动的Finder窗口
        let finderWindows = workspace.runningApplications.first { $0.bundleIdentifier == "com.apple.finder" }
        return finderWindows != nil
    }

        private func showInstallationDialog() {
        // 记录已显示安装对话框
        UserDefaults.standard.set(true, forKey: "HasShownInstallDialog")

        let alert = NSAlert()
        alert.messageText = "iGetPath 安装完成"
        alert.informativeText = "请选择您需要的功能：\n\n• 右键菜单：在右键菜单中添加\"拷贝路径\"选项\n• 工具栏按钮：在Finder工具栏中添加快捷按钮\n• 重置权限：如果已授权但仍提示权限问题"
        alert.addButton(withTitle: "启用右键菜单")
        alert.addButton(withTitle: "添加至Finder工具栏")
        alert.addButton(withTitle: "重置权限设置")
        alert.addButton(withTitle: "取消")

        let response = alert.runModal()

        switch response {
        case .alertFirstButtonReturn:
            // 打开扩展设置
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences")!)
        case .alertSecondButtonReturn:
            // 添加至Finder工具栏
            addToFinderToolbar()
        case .alertThirdButtonReturn:
            // 重置权限设置
            resetPermissionSettings()
        default:
            break
        }

        NSApp.terminate(self)
    }

    private func resetPermissionSettings() {
        UserDefaults.standard.removeObject(forKey: "HasShownPermissionAlert")
        UserDefaults.standard.removeObject(forKey: "DisablePermissionAlerts")
        UserDefaults.standard.removeObject(forKey: "HasShownInstallDialog")

        let alert = NSAlert()
        alert.messageText = "权限设置已重置"
        alert.informativeText = "所有权限提示已重置。下次使用工具栏功能时，系统会重新检查权限状态。"
        alert.addButton(withTitle: "确定")
        alert.runModal()
    }

                private func handleToolbarMode() {
        print("进入工具栏模式")

        // 添加短暂延迟，确保Finder已完全激活
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.getCurrentFinderPath { [weak self] path, isFromAppleScript in
                DispatchQueue.main.async {
                    if let validPath = path, !validPath.isEmpty {
                        if isFromAppleScript {
                            // AppleScript成功，已经处理了剪贴板和通知
                            print("工具栏模式成功 (AppleScript): \(validPath)")
                            // 验证剪贴板内容
                            let clipboardContent = NSPasteboard.general.string(forType: .string)
                            print("剪贴板内容: \(clipboardContent ?? "空")")
                        } else {
                            // 使用备用方案，需要手动处理剪贴板和通知
                            print("工具栏模式成功 (备用方案): \(validPath)")
                            self?.copyPathToClipboard(validPath)
                        }
                    } else {
                        // 完全失败
                        print("工具栏模式失败：无法获取任何路径")
                        self?.showNotification(title: "获取路径失败", body: "无法获取当前文件夹路径")
                    }

                    // 延迟退出，让用户看到反馈
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        NSApp.terminate(self)
                    }
                }
            }
        }
    }

            private func getCurrentFinderPath(completion: @escaping (String?, Bool) -> Void) {
        // 首先尝试AppleScript方法（已包含剪贴板复制和通知）
        tryAppleScriptMethod { [weak self] path in
            if let validPath = path, !validPath.isEmpty {
                // AppleScript成功，已经复制到剪贴板并显示通知
                print("AppleScript成功处理，路径: \(validPath)")
                completion(validPath, true) // true表示AppleScript成功
            } else {
                // AppleScript失败，尝试其他方法
                print("AppleScript失败，使用备用方案")
                self?.tryAlternativeMethods { backupPath in
                    completion(backupPath, false) // false表示使用备用方案
                }
            }
        }
    }

        private func tryAppleScriptMethod(completion: @escaping (String?) -> Void) {
        let script = """
        tell application "Finder"
            try
                set currentPath to the POSIX path of (the target of the front window as alias)
                set the clipboard to currentPath
                display notification "路径已成功复制到剪贴板！" with title "路径已复制" subtitle currentPath
                return currentPath
            on error
                display notification "请先打开一个访达窗口" with title "操作失败"
                return ""
            end try
        end tell
        """

        print("执行改进的AppleScript获取路径...")

        DispatchQueue.global(qos: .userInitiated).async {
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: script) {
                let result = scriptObject.executeAndReturnError(&error)

                if let error = error {
                    print("AppleScript执行错误: \(error)")

                    // 检查是否是权限错误，避免重复提示
                    let errorCode = (error["NSAppleScriptErrorNumber"] as? NSNumber)?.intValue ?? 0
                    let hasShownPermissionAlert = UserDefaults.standard.bool(forKey: "HasShownPermissionAlert")
                    let disableAlerts = UserDefaults.standard.bool(forKey: "DisablePermissionAlerts")

                    if errorCode == -10004 && !hasShownPermissionAlert && !disableAlerts {
                        // 只在第一次遇到权限错误时显示提示
                        UserDefaults.standard.set(true, forKey: "HasShownPermissionAlert")

                        DispatchQueue.main.async {
                            let alert = NSAlert()
                            alert.messageText = "需要授权访问Finder"
                            alert.informativeText = "为获取准确的Finder路径，请在系统设置中授权iGetPath访问自动化功能。\n\n授权后应用将能获取真实的Finder窗口路径。\n\n暂时使用备用方案。"
                            alert.addButton(withTitle: "打开系统设置")
                            alert.addButton(withTitle: "暂时使用备用方案")
                            alert.addButton(withTitle: "不再提示")

                            let response = alert.runModal()
                            if response == .alertFirstButtonReturn {
                                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security")!)
                            } else if response == .alertThirdButtonReturn {
                                UserDefaults.standard.set(true, forKey: "DisablePermissionAlerts")
                            }
                        }
                    }

                    completion(nil) // 返回nil表示AppleScript失败
                } else {
                    let path = result.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
                    print("AppleScript返回路径: \(path ?? "空")")
                    // 检查路径是否为空或无效
                    if let validPath = path, !validPath.isEmpty {
                        completion(validPath)
                    } else {
                        print("AppleScript返回空路径，视为失败")
                        completion(nil)
                    }
                }
            } else {
                print("无法创建AppleScript对象")
                completion(nil)
            }
        }
    }

    private func tryAlternativeMethods(completion: @escaping (String?) -> Void) {
        print("尝试备用路径获取方法...")

        // 方法1: 尝试获取最后访问的Finder窗口路径
        if let recentPath = getRecentFinderPath() {
            print("使用最近Finder路径: \(recentPath)")
            completion(recentPath)
            return
        }

        // 方法2: 尝试获取用户常用目录
        let userPreferredPaths: [String?] = [
            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
            NSHomeDirectory() + "/Downloads", // 使用更兼容的下载目录路径
            NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first,
            NSHomeDirectory()
        ]

        for path in userPreferredPaths {
            if let validPath = path, FileManager.default.fileExists(atPath: validPath) {
                print("使用备用路径: \(validPath)")
                completion(validPath)
                return
            }
        }

        // 最后的fallback
        completion(NSHomeDirectory())
    }

    private func getRecentFinderPath() -> String? {
        // 尝试从NSWorkspace获取信息
        let workspace = NSWorkspace.shared
        let frontmostApp = workspace.frontmostApplication

        if frontmostApp?.bundleIdentifier == "com.apple.finder" {
            // 如果Finder是前台应用，尝试获取用户文档目录作为合理的默认值
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        }

        return nil
    }

    private func copyPathToClipboard(_ path: String?) {
        guard let validPath = path, !validPath.isEmpty else {
            print("路径为空或无效")
            showNotification(title: "获取路径失败", body: "无法获取当前文件夹路径")
            return
        }

        print("复制路径到剪贴板: \(validPath)")

        NSPasteboard.general.clearContents()
        let success = NSPasteboard.general.setString(validPath, forType: .string)

        if success {
            print("路径复制成功")
            showNotification(title: "路径已复制", body: validPath)
        } else {
            print("路径复制失败")
            showNotification(title: "复制失败", body: "无法复制路径到剪贴板")
        }
    }

    private func showNotification(title: String, body: String) {
        print("显示通知: \(title) - \(body)")

        // 1. 尝试系统通知
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        ) { error in
            if let error = error {
                print("通知发送失败: \(error)")
                // 如果系统通知失败，显示简短的对话框
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = title
                    alert.informativeText = body
                    alert.addButton(withTitle: "确定")
                    alert.alertStyle = .informational
                    alert.runModal()
                }
            } else {
                print("通知发送成功")
            }
        }
    }

    private func addToFinderToolbar() {
        let script = """
        tell application "Finder"
            activate
            try
                tell front window
                    set toolbar visible to true
                end tell
            on error
                -- 如果没有窗口，打开一个新窗口
                make new Finder window to desktop
                tell front window
                    set toolbar visible to true
                end tell
            end try
        end tell

        delay 1

        display notification "请将 iGetPath 图标拖到 Finder 工具栏中" with title "添加到工具栏" subtitle "从应用程序文件夹拖拽到工具栏"

        tell application "Finder"
            try
                reveal (POSIX file "/Applications/iGetPath.app")
            on error
                -- 如果在Applications目录找不到，尝试当前构建位置
                set appPath to (POSIX path of (path to me))
                reveal (POSIX file appPath)
            end try
        end tell
        """

        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if error != nil {
                print("AppleScript error: \(error!)")
                showManualInstructions()
            }
        } else {
            showManualInstructions()
        }
    }

    private func showManualInstructions() {
        let alert = NSAlert()
        alert.messageText = "手动添加到工具栏"
        alert.informativeText = """
        请按照以下步骤手动添加：

        1. 打开 Finder
        2. 按 Cmd+Option+T 显示工具栏（如果未显示）
        3. 从 Applications 文件夹拖拽 iGetPath.app 到 Finder 工具栏
        4. 点击工具栏中的 iGetPath 图标即可复制当前路径

        提示：您也可以在系统设置中启用 Finder 扩展来使用右键菜单功能。
        """
        alert.addButton(withTitle: "明白了")
        alert.addButton(withTitle: "打开扩展设置")

        if alert.runModal() == .alertSecondButtonReturn {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences")!)
        }
    }
}