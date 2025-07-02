import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let alert = NSAlert()
        alert.messageText = "安装完成"
        alert.informativeText = "请在系统偏好设置 > 扩展 > Finder扩展中启用扩展。"
        alert.addButton(withTitle: "确定")
        alert.addButton(withTitle: "打开设置")

        if alert.runModal() == .alertSecondButtonReturn {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences")!)
        }

        NSApp.terminate(self)
    }
}