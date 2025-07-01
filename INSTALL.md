# getPath 安装和使用指南

## 快速开始

### 第一步：构建应用

1. **打开终端**，导航到 getPath 项目目录：
   ```bash
   cd /path/to/getPath
   ```

2. **使用 Xcode 构建**（推荐方法）：
   ```bash
   # 打开 Xcode 项目
   open getPath.xcodeproj
   ```

   在 Xcode 中：
   - 选择 "getPath" scheme
   - 点击 Product → Archive
   - 导出应用程序到桌面

3. **或使用命令行构建**：
   ```bash
   ./build.sh
   ```

### 第二步：安装应用

1. 将构建好的 `getPath.app` 复制到 `/Applications` 文件夹

2. 首次运行应用（这会注册 Finder 扩展）：
   ```bash
   open /Applications/getPath.app
   ```

### 第三步：启用扩展

选择以下任一方法：

**方法一 (推荐) - 通过 Finder 设置**：
1. 打开 **Finder**
2. 点击菜单栏 **Finder** → **设置** (或按 `⌘,`)
3. 点击 **扩展** 标签页
4. 勾选启用 **getPath Extension**

**方法二 - 通过系统设置**：
1. 打开 **系统设置** (macOS 13+ 中替代了系统偏好设置)
2. 点击 **隐私与安全性**
3. 向下滚动找到 **扩展**
4. 点击 **Finder 扩展**
5. 勾选启用 **getPath Extension**

**方法三 - 使用命令行**：
```bash
open "x-apple.systempreferences:com.apple.ExtensionsPreferences"
```

### 第四步：重启 Finder

```bash
killall Finder
```

## 使用方法

1. **打开任意 Finder 窗口**
2. **右键点击空白区域或任意文件/文件夹**
3. **在上下文菜单中选择"获取路径"**，当前文件夹的完整路径将自动复制到剪贴板
4. **查看通知**，确认路径已复制

## 功能特点

- ✅ **一键复制路径** - 快速获取当前文件夹的完整路径
- ✅ **智能识别** - 选中文件时获取其父目录路径
- ✅ **通知提示** - 复制成功后显示系统通知
- ✅ **系统集成** - 原生 Finder 右键菜单集成
- ✅ **轻量级** - 占用资源极少

## 故障排除

### 右键菜单中没有显示"获取路径"选项
- **macOS 15+**: 在系统设置 → 隐私与安全性 → 扩展 → Finder扩展中启用
- **或者**: 在 Finder → 设置 → 扩展标签页中启用
- 重启 Finder：`killall Finder`
- 重新运行主应用

### 点击菜单项没有反应
- 检查扩展是否已启用
- 查看控制台日志是否有错误信息

### 无法复制路径
- 确保有访问当前文件夹的权限
- 检查应用的安全权限设置

## 技术细节

**系统要求**：
- macOS 13.0+
- Xcode 15.0+（构建时）

**权限**：
- 文件系统访问（读取）
- 剪贴板访问
- 通知权限

**架构**：
- 主应用：负责安装和注册扩展
- Finder扩展：提供工具栏按钮和路径获取功能

## 卸载

如需卸载：
1. 在系统偏好设置中禁用扩展
2. 删除 `/Applications/getPath.app`
3. 重启 Finder