#!/bin/bash

echo "==== 测试工具栏模式 ===="

# 确保Finder是前台应用
echo "1. 启动Finder..."
osascript -e 'tell application "Finder" to activate'
sleep 1

# 从终端启动应用，这样可以看到调试输出
echo "2. 启动iGetPath (模拟工具栏点击)..."
/Applications/iGetPath.app/Contents/MacOS/iGetPath &

# 等待应用运行
sleep 3

# 检查剪贴板内容
echo "3. 检查剪贴板内容："
pbpaste

echo "==== 测试完成 ===="