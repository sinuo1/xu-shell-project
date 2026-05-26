# XU Shell 项目
## 目录结构
/mnt/XU
├── bin/            主程序启动脚本
├── conf/           全局配置、环境变量
├── lib/            通用函数库
├── tests/unit      单元测试用例
├── tests/integration 集成测试用例
├── docs/           项目文档
├── logs/           运行日志
└── tmp/            临时文件

## 使用方式
1. 赋予脚本执行权限
find . -name "*.sh" -exec chmod +x {} \;

2. 运行主程序
./bin/myinit.sh

3. 执行测试
make test
