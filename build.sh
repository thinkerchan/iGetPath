#!/bin/bash

echo "构建 iGetPath..."

if ! command -v xcodebuild &> /dev/null; then
    echo "错误: 未找到 xcodebuild"
    exit 1
fi

cd "$(dirname "$0")"

# 清理并构建项目
echo "正在清理和构建项目..."
xcodebuild clean -project iGetPath.xcodeproj -scheme iGetPath >/dev/null 2>&1
xcodebuild -project iGetPath.xcodeproj -scheme iGetPath -configuration Release build

if [ $? -eq 0 ]; then
    echo "✅ 构建成功"

    # 创建build文件夹
    mkdir -p build

    # 查找构建的app文件
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "iGetPath.app" -path "*/Build/Products/Release/*" | head -1)

    if [ -z "$APP_PATH" ]; then
        echo "❌ 未找到构建的app文件"
        exit 1
    fi

    echo "找到app文件: $APP_PATH"

    # 复制app文件到build文件夹
    echo "正在复制app文件到build文件夹..."
    cp -R "$APP_PATH" build/

    # 获取版本信息用于命名
    VERSION=$(defaults read "$APP_PATH/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "1.0")
    BUILD_NUMBER=$(defaults read "$APP_PATH/Contents/Info.plist" CFBundleVersion 2>/dev/null || echo "1")

    # 创建zip文件
    ZIP_NAME="iGetPath_v${VERSION}_build${BUILD_NUMBER}.zip"
    echo "正在创建zip包: $ZIP_NAME"

    cd build
    zip -r -q "$ZIP_NAME" iGetPath.app
    cd ..

    if [ $? -eq 0 ]; then
        echo "✅ 打包完成!"
        echo "📦 zip文件位置: $(pwd)/build/$ZIP_NAME"
        echo "📱 app文件位置: $(pwd)/build/iGetPath.app"

        # 显示文件大小
        ZIP_SIZE=$(du -h "build/$ZIP_NAME" | cut -f1)
        echo "📏 zip文件大小: $ZIP_SIZE"
    else
        echo "❌ 创建zip文件失败"
        exit 1
    fi
else
    echo "❌ 构建失败"
    exit 1
fi