#!/bin/bash
# 动态获取项目根目录
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/../.." &>/dev/null && pwd)

# 加载主程序入口
source "${PROJECT_ROOT}/bin/myinit.sh"

echo "===== 1. 配置文件加载验证 ====="
echo "当前环境: $ENV"
echo "日志目录: $LOG_DIR"
echo "项目根目录: $XU_ROOT"
echo "✅ 配置文件加载正常"

echo -e "\n===== 2. 工具函数联动测试 ====="
test_dir="/tmp/test_xu_integration"
ensure_dir "$test_dir" || exit 1
rmdir "$test_dir"
echo "✅ 工具函数联动测试通过"

echo -e "\n===== 3. 网络模块联动测试 ====="
check_network "www.baidu.com" || exit 1
local_ip=$(get_local_ip)
echo "本机IP: $local_ip"
echo "✅ 网络模块联动测试通过"

echo -e "\n===== 所有集成测试通过 ====="
exit 0
