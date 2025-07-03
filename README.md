# iGetPath

> macos右键获取当前文件夹的完整路径 ,github releases 已上传打包好的app，直接下载安装即可


## 适用人群
- 经常cd的程序员
- 经常拖拽文件夹到终端的用户
- 其他

## 功能特点

- 🔍 在 Finder 右键菜单中添加"获取路径"选项
- 🛠️ 支持添加到 Finder 工具栏，一键点击获取路径
- 📋 一键复制当前文件夹路径到剪贴板
- 🔔 显示友好的通知提示
- 🎯 支持选中文件或文件夹的父目录路径获取
- ⚡ 轻量级，占用资源极少
- 🚀 双重使用方式：右键菜单 + 工具栏按钮

## 系统要求

- macOS 13.0 或更高版本
- Xcode 15.0 或更高版本（仅构建时需要）

## 自行打包

### 方法一：使用构建脚本

1. 打开终端，导航到项目目录
2. 运行构建脚本：
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

构建完成后，您将在 `build` 文件夹中找到：
- `iGetPath.app` - 可执行的应用程序
- `iGetPath_v[版本]_build[构建号].zip` - 压缩的分发包

> 💡 **提示**：zip文件便于分享和分发，解压后即可使用。

### 方法二：使用 Xcode

1. 打开 `iGetPath.xcodeproj`
2. 选择 iGetPath scheme
3. Product → Archive
4. 导出应用程序

## 使用说明

### 安装步骤

1. **安装应用**：将构建好的 `iGetPath.app` 复制到 `/Applications` 文件夹

2. **首次运行**：双击运行 `iGetPath.app`，选择您需要的功能：
   - **启用右键菜单**：在系统设置中启用 Finder 扩展
   - **添加至Finder工具栏**：自动引导添加到工具栏

### 使用方式一：右键菜单

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
   - 在上下文菜单中选择"拷贝路径"
   - 当前文件夹路径将自动复制到剪贴板

### 使用方式二：工具栏按钮

3. **添加到工具栏**：
   - 运行应用时选择"添加至Finder工具栏"
   - 系统会自动打开 Finder 并显示应用位置
   - 将 `iGetPath.app` 拖拽到 Finder 工具栏

4. **开始使用**：
   - 在任意 Finder 窗口中点击工具栏的 iGetPath 图标
   - 当前文件夹路径将自动复制到剪贴板
   - 会显示通知确认路径已复制

> 💡 **推荐**：工具栏方式更加便捷，无需右键即可一键获取路径！






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