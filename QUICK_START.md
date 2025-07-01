# getPath 快速开始指南

## 📦 当前状态
✅ 应用已成功编译！构建产物位于：
```
~/Library/Developer/Xcode/DerivedData/getPath-*/Build/Products/Debug/getPath.app
```

## 🚀 立即开始使用

### 第一步：安装应用
```bash
# 复制应用到 Applications 文件夹
cp -r ~/Library/Developer/Xcode/DerivedData/getPath-*/Build/Products/Debug/getPath.app /Applications/

# 运行应用进行初始化
open /Applications/getPath.app
```

### 第二步：启用扩展
选择以下任一方法：

**方法一 (系统设置)**：
1. 打开 **系统设置** → **隐私与安全性** → **扩展** → **Finder扩展**
2. 勾选启用 **getPath Extension**

**方法二 (Finder设置)**：
1. 打开 **Finder** → **设置** → **扩展** 标签页
2. 勾选启用 **getPath Extension**

**方法三 (命令行)**：
```bash
open "x-apple.systempreferences:com.apple.ExtensionsPreferences"
```

### 第三步：重启 Finder
```bash
killall Finder
```

### 第四步：开始使用
1. 打开任意 Finder 窗口
2. 右键点击空白区域或任意文件/文件夹
3. 在上下文菜单中选择 **"获取路径"**
4. 路径已复制到剪贴板！🎉

## 💡 使用场景
- **开发者**：快速获取项目路径用于终端操作
- **设计师**：获取素材文件路径
- **系统管理员**：快速复制系统路径
- **任何需要路径的场景**

## 🔧 功能说明
- **智能识别**：
  - 在空白区域右键 → 获取当前文件夹路径
  - 在文件上右键 → 获取文件的父目录路径
  - 在文件夹上右键 → 获取文件夹路径

- **用户友好**：
  - 路径自动复制到剪贴板
  - 显示系统通知确认操作
  - 无需手动输入任何命令

## ❓ 遇到问题？
- **macOS 15+**: 在系统设置 → 隐私与安全性 → 扩展中启用
- **或者**: Finder → 设置 → 扩展标签页中启用
- 重启 Finder：`killall Finder`
- 查看完整的故障排除指南：`INSTALL.md`

---
**恭喜！你现在拥有了一个功能强大的路径获取工具！** 🎊