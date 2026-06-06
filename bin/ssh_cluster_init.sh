#!/bin/bash
IP_LIST_FILE="./conf/cluster.list"
# 本机生成密钥（无密码）
[ ! -d /root/.ssh ] && mkdir /root/.ssh
[ ! -f /root/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519

# 第一步：逐个推送公钥
while read ip;do
  echo "正在向 $ip 推送公钥"
  ssh-copy-id root@$ip
done < $IP_LIST_FILE

# 第二步：收集全集群所有公钥
> /root/.ssh/authorized_keys
while read ip;do
  ssh root@$ip "cat /root/.ssh/id_ed25519.pub" >> /root/.ssh/authorized_keys
done < $IP_LIST_FILE

# 第三步：统一下发汇总密钥
while read ip;do
  scp /root/.ssh/authorized_keys root@$ip:/root/.ssh/
done < $IP_LIST_FILE

echo -e "\033[32m集群全机器两两免密部署完毕\033[0m"
