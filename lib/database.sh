#!/bin/bash
# 数据库操作函数库

# 连接数据库
# 参数: host - 数据库主机, port - 数据库端口
# 返回: 0 - 成功, 1 - 失败
function db_connect() {
    local host="$1"
    local port="$2"
    if ! check_command "nc"; then
        return 1
    fi
    nc -z "$host" "$port" &>/dev/null
    return $?
}

# 检查数据库端口是否可达
# 参数: host - 数据库主机, port - 数据库端口
# 返回: 0 - 可达, 1 - 不可达
function check_db_port() {
    local host="$1"
    local port="$2"
    if ! check_command "nc"; then
        return 1
    fi
    nc -z "$host" "$port" &>/dev/null
    return $?
}
