#!/bin/bash

elasticsearch_install_dir=/web/soft/elasticsearch
elasticsearch_data_dir=/web/data/elasticsearch
elasticsearch_version=6.2.4

# add user
useradd -s /sbin/nologin -M elasticsearch

tar xvf elasticsearch-${elasticsearch_version}.tar.gz
mv elasticsearch-${elasticsearch_version} elasticsearch

# mkdir
[ ! -d ${elasticsearch_data_dir} ] && mkdir -p ${elasticsearch_data_dir}
chown -R elasticsearch: ${elasticsearch_install_dir} ${elasticsearch_data_dir}

# sysctl
echo "vm.max_map_count=300000" > /etc/sysctl.d/elasticsearch.conf
sysctl -p

# cp config
cp elasticsearch.yml ${elasticsearch_install_dir}/config/elasticsearch.yml

# add service
cp elasticsearch.service /usr/lib/systemd/system/elasticsearch.service
systemctl daemon-reload
systemctl enable --now elasticsearch.service

# firewalld
firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="113.16.199.128/26" port protocol="tcp" port="9200" accept"
firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="113.16.199.128/26" port protocol="tcp" port="9300" accept"
firewall-cmd --reload
