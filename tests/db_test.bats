#!/usr/bin/env bats
# 加载待测试的函数库
source ../lib/database.sh

@test "database connection should succeed" {
    run db_connect "localhost" "3306"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Connecting to"* ]]
}
