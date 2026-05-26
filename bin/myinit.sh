#!/bin/bash
export XU_ROOT="/mnt/XU"

# 校验并加载配置文件
if [ ! -f "${XU_ROOT}/conf/app.conf" ]; then
    echo "ERROR: 配置文件 app.conf 不存在"
    exit 1
fi
source "${XU_ROOT}/conf/app.conf"

if [ ! -f "${XU_ROOT}/conf/env.conf" ]; then
    echo "ERROR: 配置文件 env.conf 不存在"
    exit 1
fi
source "${XU_ROOT}/conf/env.conf"

# 加载函数库
source "${XU_ROOT}/lib/utils.sh"
source "${XU_ROOT}/lib/network.sh"
source "${XU_ROOT}/lib/database.sh"

# 初始化日志目录
ensure_dir "${LOG_DIR}"

# 项目启动
log_info "========== XU 项目启动 =========="
log_info "运行环境：${ENV}"
log_info "调试模式：${DEBUG}"

# 基础环境检测
check_command ping
check_network

log_info "========== 初始化完成 =========="
exit 0
