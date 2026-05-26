#!/bin/bash
# 动态获取项目根目录
export XU_ROOT="/mnt/hgfs/XU"

# 先加载 utils.sh
source "${XU_ROOT}/lib/utils.sh" || {
    echo "❌ utils.sh 未找到，请检查项目结构" >&2
    exit 1
}

# 数据库端口检测
check_db_port(){
    local host="$1"
    local port="$2"
    check_command nc || return 1
    log_info "检测数据库端口 $host:$port"
    if nc -z -w ${DEFAULT_TIMEOUT} "$host" "$port" &>/dev/null; then
        log_info "数据库端口正常"
        return 0
    else
        log_error "数据库端口异常"
        return 1
    fi
}
