import Cocoa
import SystemExtensions

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 启动Finder Sync扩展
        guard let extensionBundle = Bundle.main.builtInPlugInsURL?.appendingPathComponent("getPathExtension.appex") else {
            print("无法找到扩展")
            return
        }

        // 激活扩展
        NSWorkspace.shared.open(extensionBundle)

        // 显示安装完成提示
        let alert = NSAlert()
        alert.messageText = "getPath 安装完成"
        alert.informativeText = "请在系统偏好设置 > 扩展 > Finder扩展中启用getPath扩展，然后重启Finder。"
        alert.addButton(withTitle: "好的")
        alert.addButton(withTitle: "打开系统偏好设置")

        let response = alert.runModal()
        if response == .alertSecondButtonReturn {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences")!)
        }

        NSApp.terminate(self)
    }
}