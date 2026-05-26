#!/usr/bin/env bats
source ../lib/database.sh

@test "database connection should succeed" {
    run db_connect "localhost" "3306"
    [ "$status" -eq 0 ]
}
