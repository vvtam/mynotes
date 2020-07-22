import sys
import logging
from pyzabbix import ZabbixAPI
import time
import re
import xlwt
import json


class zabbix_main():
    def __init__(self):
        self.server_info = None
        self.api = None

    @staticmethod
    def get_two_float(f_str, n):
        """
        :param f_str: 浮点数
        :param n:  返回小数点后 n 位
        :return:
        """
        f_str = str(f_str)
        a, b, c = f_str.partition('.')
        # 如论传入的函数有几位小数，在字符串后面都添加n为小数0
        c = (c + "0" * n)[:n]
        return float(".".join([a, c]))

    def connect(self, server_info):
        api_server = ZabbixAPI(server_info[2])
        api_server.login(server_info[3], server_info[4])
        return api_server

    def get_host(self, api_server):
        hosts = api_server.host.get(output=['host'],selectInterfaces=['ip'])
        result = []
        for host in hosts:
            host['ip'] = host['interfaces'][0]
            del host['interfaces']
            result.append(host)
        return hosts

    def mem_info(self, api_server, host):
        # 获取内存数据
        mems = api_server.item.get(
            output=["name", "lastvalue"],
            hostids=host['hostid'],
            search={"key_": "vm.memory.size"},
            sortfield="name"
        )
        use_val = [i.get('lastvalue') for i in mems if i.get('name') == 'Available memory']
        total_val = [i.get('lastvalue') for i in mems if i.get('name') == 'Total memory']
        # 使用率
        puse_mem = int(use_val[0]) / int(total_val[0])

        # 内存大小
        total_mem = float(total_val[0]) / 1024 / 1024 / 1024

        puse_mem= self.get_two_float(100 - (float(puse_mem) * 100), 2)
        total_mem = self.get_two_float(float(total_mem), 2)

        return puse_mem, total_mem

    def cpu_info(self, api_server, host):
        # 获取CPU数据
        cpus = api_server.item.get(
            output=["lastvalue"],
            hostids=host['hostid'],
            search={"key_": "system.cpu.util[,idle]"},
            sortfield="name"
        )

        return self.get_two_float(100 - float(cpus[0]['lastvalue']), 2)

    def disk_info(self, api_server, host):
        # 获取磁盘数据
        disks = api_server.item.get(
            output=["key_", "lastvalue"],
            # output="extend",
            hostids=host['hostid'],
            search={"key_": "vfs.fs.size"},
            sortfield="name"
        )
        puse_disk_list = []
        total_disk_list = []

        for j in disks:
            # 分区及使用率
            if 'pfree' in j['key_']:
                partitions = re.sub(r'vfs.fs.size\[|,pfree\]', '', j['key_'])
                puse_disk = self.get_two_float(100 - float(j['lastvalue']), 2)
                tmp_dict = {'part': partitions, 'puse': puse_disk}

                puse_disk_list.append(tmp_dict)
            if 'pused' in j['key_']:
                partitions = re.sub(r'vfs.fs.size\[|,pused\]', '', j['key_'])
                puse_disk = self.get_two_float(float(j['lastvalue']), 2)
                tmp_dict = {'part': partitions, 'puse': puse_disk}
                puse_disk_list.append(tmp_dict)
            # 分区及总大小
            if 'total' in j['key_']:
                partitions = re.sub(r'vfs.fs.size\[|,total]', '', j['key_'])
                total_disk = self.get_two_float(int(j['lastvalue']) / 1024 / 1024 / 1024, 2)
                tmp_dict = {'part': partitions, 'total': total_disk}
                total_disk_list.append(tmp_dict)

        tmp1 = []
        print(puse_disk_list, total_disk_list)
        # 合并出分区 使用率 大小
        for l in puse_disk_list:
            tmp_list1 = [m['total'] for m in total_disk_list if l['part'] == m['part']]
            tmp2 = {"partition": l['part'],"total": tmp_list1[0], "util": l.get('puse')}
            tmp1.append(tmp2)
        print(tmp1)
        return tmp1


def setStyle(color):
    style = xlwt.XFStyle()  # 初始化样式
    # 设置背景颜色
    pattern = xlwt.Pattern()
    # 设置背景颜色的模式
    pattern.pattern = xlwt.Pattern.SOLID_PATTERN
    # 背景颜色
    pattern.pattern_fore_colour = color
    style.pattern = pattern
    return style
    

def main_entrance():
    zabbix = zabbix_main()
    # sql="select * from ZabbixApi"
    # zabbix.cmd_sql(sql)
    # serverinfo = zabbix.server_info
    serverinfo = [
        (2, 'xx', ' http://1.5.2.0.5/', 'admin', 'xxx'),
    ]

    for i in serverinfo:
        api_server = zabbix.connect(i)
        host_list = zabbix.get_host(api_server)
        host_info = dict()

        # 创建一个workbook 设置编码
        workbook = xlwt.Workbook(encoding='utf-8')
        # 创建一个worksheet
        worksheet = workbook.add_sheet('sheet1', cell_overwrite_ok=True)

        num = 1
        worksheet.write(0, 0, label="ip")
        worksheet.write(0, 1, label="主机名")
        worksheet.write(0, 2, label="内存总量/G")
        worksheet.write(0, 3, label="内存使用率/%")
        worksheet.write(0, 4, label="CPU使用率/%")
        for host in host_list:
            host_info['hostid'] = host['hostid']
            host_info['ip'] = host['ip']['ip']
            host_info['hostname'] = host['host']
            host_info['server'] = i[0]
            try:
                host_info['puse_mem'], host_info['total_mem'] = zabbix.mem_info(api_server, host)
                host_info['cpu'] = zabbix.cpu_info(api_server, host)
                # 写入excel 参数对应 行, 列, 值
                worksheet.write(num, 0, label=host_info['ip'])
                worksheet.write(num, 1, label=host_info['hostname'])
                worksheet.write(num, 2, label=host_info['total_mem'])
                if host_info['puse_mem'] >= 80:
                    worksheet.write(num, 3, host_info['puse_mem'], setStyle(2))
                else:
                    worksheet.write(num, 3, host_info['puse_mem'])

                if host_info['cpu'] >= 80:
                    worksheet.write(num, 4, host_info['cpu'], setStyle(2))
                else:
                    worksheet.write(num, 4, host_info['cpu'])
                num1 = 5
                for j in zabbix.disk_info(api_server, host):
                    worksheet.write(0, num1, label="分区")
                    worksheet.write(0, num1+1, label="大小/G")
                    worksheet.write(0, num1+2, label="使用率/%")
                    for k in j:
                        if k == 'util' and int(j[k]) >= 80:
                            worksheet.write(num, num1, j[k], setStyle(2))
                        else:
                            worksheet.write(num, num1, label=j[k])

                        num1 += 1

                num += 1
            except Exception as e:
                print(e)
                continue

        workbook.save("{}.xls".format(i[1]))

main_entrance()