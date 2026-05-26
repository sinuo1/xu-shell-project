#!/bin/bash
# 动态获取脚本所在目录和项目根目录
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/../.." &>/dev/null && pwd)

# 加载依赖（用绝对路径）
source "${PROJECT_ROOT}/lib/utils.sh"

echo "===== 测试日志输出函数 ====="
log_info "Info 日志测试"
log_warn "Warn 日志测试"
log_error "Error 日志测试"
echo "✅ 日志函数测试通过"

echo -e "\n===== 测试目录创建函数 ====="
test_dir="/tmp/test_xu_utils_$(date +%s)"
ensure_dir "$test_dir"
if [ -d "$test_dir" ]; then
    echo "✅ ensure_dir 测试通过"
    rmdir "$test_dir"
else
    echo "❌ ensure_dir 测试失败"
    exit 1
fi

echo -e "\n===== 测试命令检查函数 ====="
check_command "ping"
if [ $? -eq 0 ]; then
    echo "✅ check_command 测试通过"
else
    echo "❌ check_command 测试失败"
    exit 1
fi

echo -e "\n===== 所有单元测试通过 ====="
exit 0
