# XU Shell Project

一个模块化、可扩展的 Shell 工具集，提供通用函数库、单元测试与集成测试支持。

---

## 📁 项目目录结构

```text
/mnt/XU
├── bin/                # 主程序启动脚本
├── conf/               # 全局配置、环境变量
├── lib/                # 通用函数库
│   ├── utils.sh        # 公共工具函数（如 check_command、log_*、ensure_dir）
│   └── database.sh     # 数据库相关函数（含端口检测）
├── tests/
│   ├── unit/           # 单元测试用例
│   │   ├── test_utils.sh
│   │   ├── test_network.sh
│   │   └── test_database.sh
│   └── integration/    # 集成测试用例
├── docs/               # 项目文档
├── logs/               # 运行日志目录
├── tmp/                # 临时文件目录
├── Makefile            # 项目构建与测试管理
└── README.md           # 项目说明文档
🚀 快速开始
1. 环境准备
确保系统中已安装以下依赖：
bash / sh
netcat (nc) 或 nmap-ncat
make（用于执行测试）
2. 赋予脚本执行权限
bash
运行
find . -name "*.sh" -exec chmod +x {} \;
3. 运行主程序
bash
运行
./bin/myinit.sh
4. 执行单元测试
bash
运行
make test
📦 核心模块说明
lib/utils.sh
提供项目通用工具函数，已包含：
check_command: 检查依赖命令是否存在
log_info / log_warn / log_error: 日志输出函数
ensure_dir: 确保目录存在
lib/database.sh
数据库相关操作函数库，已实现：
check_db_port: 检测本地 3306 端口是否开放
db_connect: 数据库连接逻辑封装
tests/unit/test_database.sh
数据库模块单元测试用例：
依赖检查：验证 nc 命令是否可用
端口检测：调用 check_db_port 验证 3306 端口可达性
优雅降级：端口未开放时自动跳过测试，不影响整体流程
✅ 已解决的关键问题
根据最新提交 9437d35，修复了以下问题：
函数未定义错误：在 lib/database.sh 中补充实现了 check_db_port 函数，解决了 command not found 报错
测试逻辑优化：完善了端口检测逻辑，使用 nc -z 检查端口可达性，并在端口未开放时优雅跳过测试
依赖加载顺序：确保 utils.sh 先于 database.sh 加载，避免公共函数缺失
📝 开发规范
分支管理：功能开发与修复在 develop 分支进行，稳定版本合并至 main
提交规范：提交信息格式为 type: description，如 fix: 补充 check_db_port 函数
测试覆盖：新增功能需配套单元测试，确保核心逻辑可验证
