ROOT_DIR := $(shell pwd)
SHELL := /bin/bash

BIN := $(wildcard bin/*.sh)
LIB := $(wildcard lib/*.sh)
TEST_UNIT := $(wildcard tests/unit/*.sh)
TEST_INTEG := $(wildcard tests/integration/*.sh)

.PHONY: all unit-test integration-test test clean help

all: help

# 单元测试
unit-test:
	@echo "===== 执行单元测试 ====="
	@chmod +x $(TEST_UNIT)
	@for s in $(TEST_UNIT); do ./$$s || exit 1; done
	@echo "✅ 单元测试完成"

# 集成测试
integration-test:
	@echo "===== 执行集成测试 ====="
	@chmod +x $(TEST_INTEG)
	@for s in $(TEST_INTEG); do ./$$s || exit 1; done
	@echo "✅ 集成测试完成"

# 全套测试
test: unit-test integration-test
	@echo "===== 所有测试执行完毕 ====="

# 清理临时文件
clean:
	rm -rf tmp/* *.tmp *.log
	@echo "✅ 清理完成"

# 帮助
help:
	@echo "命令列表："
	@echo "  make unit-test      运行单元测试"
	@echo "  make integration-test 运行集成测试"
	@echo "  make test           运行全部测试"
	@echo "  make clean          清理临时文件"
