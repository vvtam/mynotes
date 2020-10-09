# Zeal 

Docs for everyone

## 配置文档的其它版本

Zeal只下载最新版本文档，需要其它版本，可以下载DASH的离线文档，比如ansible

最新的版本

```
<entry>
    <version>2.10.1</version>
    <ios_version>1</ios_version>
    <url>http://sanfrancisco.kapeli.com/feeds/Ansible.tgz</url>
    <url>http://london.kapeli.com/feeds/Ansible.tgz</url>
    <url>http://newyork.kapeli.com/feeds/Ansible.tgz</url>
    <url>http://tokyo.kapeli.com/feeds/Ansible.tgz</url>
    <url>http://frankfurt.kapeli.com/feeds/Ansible.tgz</url>
    <url>http://singapore.kapeli.com/feeds/Ansible.tgz</url>
    <other-versions>
        <version><name>2.10.1</name></version>
        <version><name>2.10.0</name></version>
        <version><name>2.9.12</name></version>
        <version><name>2.9.11</name></version>
        <version><name>2.9.10</name></version>
        <version><name>2.9.9</name></version>
        <version><name>2.9.7</name></version>
        <version><name>2.9.6</name></version>
        <version><name>1.9.4</name></version>
    </other-versions>
</entry>
```

离线的版本

```
http://sanfrancisco.kapeli.com/feeds/zzz/versions/{DocsetName}/{version}/{DocsetName}.tgz
http://london.kapeli.com/feeds/zzz/versions/{DocsetName}/{version}/{DocsetName}.tgz
http://newyork.kapeli.com/feeds/zzz/versions/{DocsetName}/{version}/{DocsetName}.tgz
http://tokyo.kapeli.com/feeds/zzz/versions/{DocsetName}/{version}/{DocsetName}.tgz
http://frankfurt.kapeli.com/feeds/zzz/versions/{DocsetName}/{version}/{DocsetName}.tgz
http://singapore.kapeli.com/feeds/zzz/versions/{DocsetName}/{version}/{DocsetName}.tgz
```

解压放到Zeal文档的目录，修改`Zeal\docsets\Ansible.docset\Contents\Info.plist`

