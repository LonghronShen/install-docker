#!/bin/bash

set -x

sed -i -E 's/http:\/\/(.*\.)?(archive|security).ubuntu.com/https:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list

echo "Checking docker..."
if [[ "$(which docker)" == "" ]]; then
    echo "Docker not found. Installing."
    curl -sSL https://get.daocloud.io/docker | sh
    curl -L https://get.daocloud.io/docker/compose/releases/download/v2.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo "Docker installed."
fi

mkdir -p /etc/systemd/system/docker.service.d
envsubst < ./http-proxy.conf.template > /etc/systemd/system/docker.service.d/http-proxy.conf

systemctl daemon-reload
systemctl show --property Environment docker

systemctl restart docker