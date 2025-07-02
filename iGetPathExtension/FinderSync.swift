import Cocoa
import FinderSync
import UserNotifications

class FinderSync: FIFinderSync {

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    override func beginObservingDirectory(at url: URL) {}
    override func endObservingDirectory(at url: URL) {}

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        guard menuKind == .contextualMenuForItems || menuKind == .contextualMenuForContainer else {
            return nil
        }
        let menu = NSMenu(title: "")
        let menuItem = NSMenuItem(title: "拷贝路径", action: #selector(iGetPathAction(_:)), keyEquivalent: "")
        menuItem.target = self
        menu.addItem(menuItem)
        return menu
    }

    @objc func iGetPathAction(_ sender: NSMenuItem) {
        let target = FIFinderSyncController.default()
        var path: String?

        if let selectedItems = target.selectedItemURLs(), !selectedItems.isEmpty {
            let firstItem = selectedItems[0]
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: firstItem.path, isDirectory: &isDirectory) {
                path = isDirectory.boolValue ? firstItem.path : firstItem.deletingLastPathComponent().path
            }
        } else if let targetUrl = target.targetedURL() {
            path = targetUrl.path
        }

        guard let validPath = path else { return }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(validPath, forType: .string)

        let content = UNMutableNotificationContent()
        content.title = "路径已复制"
        content.body = validPath
        content.sound = .default

        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: "pathCopied", content: content, trigger: nil)
        ) { _ in }
    }
}