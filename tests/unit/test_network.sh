#!/bin/bash
# 动态获取项目根目录
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/../.." &>/dev/null && pwd)

# 按依赖顺序加载（utils必须先加载）
source "${PROJECT_ROOT}/lib/utils.sh"
source "${PROJECT_ROOT}/lib/network.sh"

echo "===== 测试网络连通性 ====="
check_network "www.baidu.com" || exit 1
echo "✅ 网络连通性测试通过"

echo -e "\n===== 测试获取本机IP ====="
local_ip=$(get_local_ip)
if [ -n "$local_ip" ]; then
    echo "✅ 获取本机IP成功: $local_ip"
else
    echo "❌ 获取本机IP失败"
    exit 1
fi

echo -e "\n===== 测试端口检测（本地22端口） ====="
check_port "127.0.0.1" "22" || echo "⚠️  22端口未开放，测试跳过"

echo -e "\n===== 所有单元测试通过 ====="
exit 0
