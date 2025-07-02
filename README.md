# iGetPath

一个简单易用的 Mac 应用程序，在 Finder 工具栏中添加按钮，一键获取当前文件夹的完整路径。

## 功能特点

- 🔍 在 Finder 右键菜单中添加"获取路径"选项
- 📋 一键复制当前文件夹路径到剪贴板
- 🔔 显示友好的通知提示
- 🎯 支持选中文件或文件夹的父目录路径获取
- ⚡ 轻量级，占用资源极少

## 系统要求

- macOS 13.0 或更高版本
- Xcode 15.0 或更高版本（仅构建时需要）

## 安装方法

### 方法一：使用构建脚本

1. 打开终端，导航到项目目录
2. 运行构建脚本：
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

### 方法二：使用 Xcode

1. 打开 `iGetPath.xcodeproj`
2. 选择 iGetPath scheme
3. Product → Archive
4. 导出应用程序

## 使用说明

1. **安装应用**：将构建好的 `iGetPath.app` 复制到 `/Applications` 文件夹

2. **首次运行**：双击运行 `iGetPath.app`，会显示安装完成提示

3. **启用扩展**：
   - **macOS 15+**: 系统设置 → 隐私与安全性 → 扩展 → Finder扩展
   - **或者**: Finder → 设置 → 扩展标签页
   - 勾选启用 "iGetPath Extension"

4. **重启 Finder**：
   ```bash
   killall Finder
   ```

5. **开始使用**：
   - 在任意 Finder 窗口中右键点击空白区域或文件/文件夹
   - 在上下文菜单中选择"获取路径"
   - 当前文件夹路径将自动复制到剪贴板
   - 会显示通知确认路径已复制

## 工作原理

- 使用 FinderSync 扩展框架集成到 Finder 上下文菜单
- 检测当前 Finder 窗口的路径
- 自动复制路径到系统剪贴板
- 显示 macOS 原生通知

## 技术实现

- **主应用**：Swift + Cocoa
- **扩展**：FinderSync 框架
- **通知**：NSUserNotification
- **剪贴板**：NSPasteboard

## 许可证

MIT License

## 支持

如有问题或建议，请提交 Issue。