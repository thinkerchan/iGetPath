import Cocoa
import FinderSync
import UserNotifications

class FinderSync: FIFinderSync {

    override init() {
        super.init()

        // 监控用户的主目录
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]

        // 请求通知权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("通知权限请求失败: \(error)")
            }
        }
    }

    // MARK: - Primary Finder Sync protocol methods

    override func beginObservingDirectory(at url: URL) {
        // 当开始监控目录时调用
    }

    override func endObservingDirectory(at url: URL) {
        // 当停止监控目录时调用
    }

        // MARK: - Menu support

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        guard menuKind == .contextualMenuForItems || menuKind == .contextualMenuForContainer else {
            return nil
        }

        let menu = NSMenu(title: "")
        let menuItem = NSMenuItem(title: "GetPath", action: #selector(getPathAction(_:)), keyEquivalent: "")
        menuItem.target = self
        menu.addItem(menuItem)

        return menu
    }

    @objc func getPathAction(_ sender: NSMenuItem) {
        let target = FIFinderSyncController.default()

        // 如果有选中的项目，获取第一个选中项目的目录
        if let selectedItems = target.selectedItemURLs(), !selectedItems.isEmpty {
            let firstItem = selectedItems[0]
            var targetPath = firstItem.path

            // 如果选中的是文件，获取其父目录
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: targetPath, isDirectory: &isDirectory) {
                if !isDirectory.boolValue {
                    targetPath = firstItem.deletingLastPathComponent().path
                }
            }
            copyPathToClipboard(targetPath)
        } else if let targetUrl = target.targetedURL() {
            // 没有选中项目，获取当前目录
            copyPathToClipboard(targetUrl.path)
        } else {
            showAlert(message: "无法获取当前目录路径")
        }
    }

    private func copyPathToClipboard(_ path: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(path, forType: .string)

        // 显示通知
        showNotification(path: path)
    }

    private func showNotification(path: String) {
        // 使用 UserNotifications 框架
        let content = UNMutableNotificationContent()
        content.title = "路径已复制"
        content.body = path
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "getPath.pathCopied",
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知发送失败: \(error)")
            }
        }
    }

    private func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "getPath"
            alert.informativeText = message
            alert.addButton(withTitle: "确定")
            alert.runModal()
        }
    }
}