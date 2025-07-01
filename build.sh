#!/bin/bash

# getPath 构建脚本

echo "开始构建 getPath 应用..."

# 检查是否安装了 Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "错误: 未找到 xcodebuild。请确保已安装 Xcode。"
    exit 1
fi

# 切换到项目目录
cd "$(dirname "$0")"

# 清理之前的构建
echo "清理之前的构建..."
xcodebuild clean -project getPath.xcodeproj -scheme getPath

# 构建应用
echo "构建应用..."
xcodebuild -project getPath.xcodeproj -scheme getPath -configuration Release build

if [ $? -eq 0 ]; then
    echo "✅ 构建成功！"
    echo ""
    echo "构建产物位置:"
    echo "~/Library/Developer/Xcode/DerivedData/getPath-*/Build/Products/Release/getPath.app"
    echo ""
    echo "安装说明:"
    echo "1. 将 getPath.app 复制到 /Applications 文件夹"
    echo "2. 运行 getPath.app"
    echo "3. 在系统偏好设置 > 扩展 > Finder扩展 中启用 getPath Extension"
    echo "4. 重启 Finder (在终端中运行: killall Finder)"
    echo "5. 在 Finder 工具栏中就会出现'获取路径'按钮"
else
    echo "❌ 构建失败！"
    exit 1
fi