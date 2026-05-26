#!/bin/bash
# 动态获取项目根目录
export XU_ROOT="/mnt/hgfs/XU"

# 先加载 utils.sh
source "${XU_ROOT}/lib/utils.sh" || {
    echo "❌ utils.sh 未找到，请检查项目结构" >&2
    exit 1
}

# 网络连通性检测
check_network(){
    local host=${1:-"www.baidu.com"}
    local timeout=${2:-${DEFAULT_TIMEOUT}}
    log_info "检测网络：$host"
    if ping -c 1 -W "$timeout" "$host" &>/dev/null; then
        log_info "网络正常"
        return 0
    else
        log_error "网络不通"
        return 1
    fi
}

# 获取本机IP
get_local_ip(){
    ip addr | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1 | head -n1
}

# 端口检测
check_port(){
    local host="$1"
    local port="$2"
    check_command nc || return 1
    if nc -z -w ${DEFAULT_TIMEOUT} "$host" "$port" &>/dev/null; then
        log_info "端口 $host:$port 开放"
        return 0
    else
        log_error "端口 $host:$port 未开放"
        return 1
    fi
}
