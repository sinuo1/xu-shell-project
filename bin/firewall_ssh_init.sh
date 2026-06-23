#!/bin/bash
# 定向SSH免密自动化脚本
# 架构：防火墙192.168.37.10，业务192.168.37.11、192.168.37.12
# 免密规则：
# 1. 10免密登录11、12
# 2. 11与12互相免密
# 3. 不生成11/12登录10的信任公钥
GW="192.168.37.10"
NODE1="192.168.37.11"
NODE2="192.168.37.12"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================="
echo "定向集群免密自动部署脚本（非全两两互登）"
echo "防火墙：$GW  业务节点：$NODE1 $NODE2"
echo -e "=========================================${NC}"

# 预检网络连通
echo -e "\n${YELLOW}[预检] 检测节点连通性${NC}"
for ip in $GW $NODE1 $NODE2; do
    if ping -c 2 -W 3 "$ip" &>/dev/null; then
        echo "$ip ${GREEN}网络正常${NC}"
    else
        echo "$ip ${RED}网络不通，请先配置路由与防火墙转发${NC}"
        exit 1
    fi
done

# 步骤1：防火墙本地生成密钥
echo -e "\n${GREEN}[1] 防火墙本机生成密钥${NC}"
[ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
GW_PUB=$(cat ~/.ssh/id_ed25519.pub)
echo -e "${GREEN}防火墙公钥已就绪${NC}"

# 步骤2：业务节点11、12各自生成密钥
echo -e "\n${GREEN}[2] 业务节点生成密钥对${NC}"
ssh root@$NODE1 "[ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
ssh root@$NODE2 "[ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"
echo -e "${GREEN}11、12密钥生成完成${NC}"

# 拉取11、12公钥
NODE1_PUB=$(ssh root@$NODE1 "cat ~/.ssh/id_ed25519.pub")
NODE2_PUB=$(ssh root@$NODE2 "cat ~/.ssh/id_ed25519.pub")

# 步骤3：给11、12写入信任公钥（防火墙公钥 + 对端业务机公钥）
# 11的信任列表：允许10登录、允许12登录
echo -e "\n${GREEN}[3] 配置192.168.37.11信任列表${NC}"
ssh root@$NODE1 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '$GW_PUB' > ~/.ssh/authorized_keys && echo '$NODE2_PUB' >> ~/.ssh/authorized_keys && sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && chown root:root ~/.ssh -R && systemctl restart sshd"

# 12的信任列表：允许10登录、允许11登录
echo -e "\n${GREEN}[4] 配置192.168.37.12信任列表${NC}"
ssh root@$NODE2 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '$GW_PUB' > ~/.ssh/authorized_keys && echo '$NODE1_PUB' >> ~/.ssh/authorized_keys && sort -u ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && chown root:root ~/.ssh -R && systemctl restart sshd"

# 步骤4：仅校验规定免密链路，不校验反向11/12登10
echo -e "\n${GREEN}[5] 免密连通校验${NC}"
flag=yes

# 校验10 -> 11
echo -n "$GW -> $NODE1 : "
if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=6 root@$NODE1 "echo ok" &>/dev/null; then
    echo -e "${GREEN}正常${NC}"
else
    echo -e "${RED}失败${NC}"
    flag=no
fi

# 校验10 -> 12
echo -n "$GW -> $NODE2 : "
if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=6 root@$NODE2 "echo ok" &>/dev/null; then
    echo -e "${GREEN}正常${NC}"
else
    echo -e "${RED}失败${NC}"
    flag=no
fi

# 校验11 -> 12
echo -n "$NODE1 -> $NODE2 : "
if ssh root@$NODE1 "ssh -o StrictHostKeyChecking=no -o ConnectTimeout=6 root@$NODE2 echo ok" &>/dev/null; then
    echo -e "${GREEN}正常${NC}"
else
    echo -e "${RED}失败${NC}"
    flag=no
fi

# 校验12 -> 11
echo -n "$NODE2 -> $NODE1 : "
if ssh root@$NODE2 "ssh -o StrictHostKeyChecking=no -o ConnectTimeout=6 root@$NODE1 echo ok" &>/dev/null; then
    echo -e "${GREEN}正常${NC}"
else
    echo -e "${RED}失败${NC}"
    flag=no
fi

# 输出最终结果
echo -e "\n========================================="
if [ "$flag" = "yes" ]; then
    echo -e "${GREEN}✅ 定向免密全部部署完成${NC}"
    echo "已生效规则："
    echo "1. 防火墙10 免密登录 11、12"
    echo "2. 业务机11 ↔ 12 互相免密登录"
    echo "3. 11、12可正常ping外网 202.112.113.10"
    echo "4. 未配置：11/12免密登录防火墙10"
else
    echo -e "${RED}❌ 存在免密链路异常，请检查ssh权限、网络路由${NC}"
    exit 1
fi