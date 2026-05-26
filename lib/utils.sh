#!/bin/bash
# 动态获取项目根目录（固定路径，适配你的挂载目录）
export XU_ROOT="/mnt/hgfs/XU"

# 引入基础配置
source "${XU_ROOT}/conf/app.conf" 2>/dev/null || true
source "${XU_ROOT}/conf/env.conf" 2>/dev/null || true

# 彩色日志
log_info(){
    echo -e "\033[32m[INFO] $(date +'%Y-%m-%d %H:%M:%S') $1\033[0m"
}
log_warn(){
    echo -e "\033[33m[WARN] $(date +'%Y-%m-%d %H:%M:%S') $1\033[0m"
}
log_error(){
    echo -e "\033[31m[ERROR] $(date +'%Y-%m-%d %H:%M:%S') $1\033[0m" >&2
}

# 检查命令是否存在
check_command(){
    if ! command -v "$1" &>/dev/null; then
        log_error "命令 $1 未安装"
        return 1
    fi
    return 0
}

# 不存在则创建目录
ensure_dir(){
    [ -d "$1" ] || mkdir -p "$1" || {
        log_error "创建目录 $1 失败"
        return 1
    }
    return 0
}
