#!/bin/bash

echo "构建 iGetPath..."

if ! command -v xcodebuild &> /dev/null; then
    echo "错误: 未找到 xcodebuild"
    exit 1
fi

cd "$(dirname "$0")"

xcodebuild clean -project iGetPath.xcodeproj -scheme iGetPath >/dev/null 2>&1
xcodebuild -project iGetPath.xcodeproj -scheme iGetPath -configuration Release build

if [ $? -eq 0 ]; then
    echo "✅ 构建成功"
    echo "位置: ~/Library/Developer/Xcode/DerivedData/iGetPath-*/Build/Products/Release/iGetPath.app"
else
    echo "❌ 构建失败"
    exit 1
fi