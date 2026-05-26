#!/bin/bash
set -e

echo "===== 开始安装系统依赖 ====="
sudo yum update -y
sudo yum install -y git bash make

echo "===== 安装Bats测试框架 ====="
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
cd ..
rm -rf bats-core

echo "===== 安装VSCode开发插件 ====="
code --install-extension gitlens.gitlens
code --install-extension mads-hartmann.bash-ide-vscode

echo "===== 环境初始化完成 ====="
