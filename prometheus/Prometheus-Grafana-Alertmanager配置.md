# Prometheus，Grafana，Alertmanager配置

## prometheus介绍

![img](pic/architecture.png)

## 安装prometheus



## 安装grafana



## 安装alertmanager



## grafana关联prometheus

grafana 默认用户密码为admin admin

导入prometheus地址，新建dashboard，设置metrics

## prometheus关联alertmanager

Prometheus配置文件定义Alertmanager

```yaml
# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets: ['127.0.0.1:9093']

```

## prometheus定义告警规则

prometheus配置文件定义相关规则

```yaml
# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  - "rules/test_rules.yml"
  #- "second_rules.yml"

```

## alertmanager触发告警

这里定义了告警发送到企业微信

```yaml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'wechat'
receivers:
- name: 'web.hook'
  webhook_configs:
  - url: 'http://127.0.0.1:5001/'
- name: 'wechat'
  wechat_configs:
  - corp_id: '3'
    to_party: '1'
    agent_id: '1000002'
    api_secret: 'N'
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']

```

