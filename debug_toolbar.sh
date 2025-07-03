#!/bin/bash

echo "==== 详细测试工具栏模式 ===="

# 清空剪贴板
echo "" | pbcopy
echo "1. 清空剪贴板完成"

# 显示当前剪贴板内容
echo "2. 剪贴板初始内容："
pbpaste | xxd -l 50  # 以十六进制显示，便于看清内容

# 启动Finder并切换到特定目录
echo "3. 启动Finder并切换到Desktop..."
osascript -e 'tell application "Finder" to activate'
osascript -e 'tell application "Finder" to open desktop'
sleep 2

# 从终端启动应用，显示所有输出
echo "4. 启动iGetPath (模拟工具栏点击)..."
echo "应用输出："
/Applications/iGetPath.app/Contents/MacOS/iGetPath

# 等待应用完成
sleep 2

# 检查新的剪贴板内容
echo "5. 检查新的剪贴板内容："
echo "原始内容: '$(pbpaste)'"
echo "十六进制:"
pbpaste | xxd -l 100

echo "==== 调试完成 ===="