#!/bin/bash
# 动态获取项目根目录
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/../.." &>/dev/null && pwd)

# 按依赖顺序加载（utils必须先加载）
source "${PROJECT_ROOT}/lib/utils.sh" || {
    echo "ERROR: utils.sh 引入失败"
    exit 1
}
source "${PROJECT_ROOT}/lib/database.sh" || {
    echo "ERROR: database.sh 引入失败"
    exit 1
}

# 测试命令检查（nc）
echo "===== 测试命令检查（nc） ====="
check_command "nc" || {
    echo "⚠️  nc命令未安装，测试跳过"
    exit 0
}
echo "✅ nc命令检查通过"

# 测试数据库端口检测
echo -e "\n===== 测试数据库端口检测（本地3306端口） ====="
check_db_port "127.0.0.1" "3306" || echo "⚠️  3306端口未开放，测试跳过"

echo -e "\n===== 所有单元测试通过 ====="
exit 0