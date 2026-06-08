# 数据库端口检测函数
# 参数: host - 主机地址, port - 端口号
# 返回: 0 - 端口开放, 1 - 端口未开放
function check_db_port() {
    local host="$1"
    local port="$2"

    # 参数校验
    if [ -z "$host" ] || [ -z "$port" ]; then
        echo "ERROR: check_db_port 需要传入主机和端口参数"
        return 1
    fi

    # 使用 nc 检测端口是否开放
    nc -z "$host" "$port"
    return $?
}