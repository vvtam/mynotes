#!/usr/bin/env python3
# coding: __utf8__

import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication


class SendMail(object):
    def __init__(self, toaddrs, ccaddrs, title, content):
        self.toaddrs = toaddrs  # 发送地址
        self.ccaddrs = ccaddrs  # 抄送地址
        self.title = title  # 标题
        self.content = content  # 发送内容
        self.fromaddr = 'fromaddr'  # fromaddr
        self.smtp_password = 'pw'  # password

    def send(self, file_list):
        """
        发送邮件
        :param file_list: 附件文件列表
        :return: bool
        """
        try:
            # 创建一个带附件的实例
            msg = MIMEMultipart()
            # 发件人格式
            msg['From'] = formataddr(["zabbix", self.fromaddr])
            # 收件人格式
            msg['To'] = ", ".join(toaddrs)
            msg['Cc'] = ", ".join(ccaddrs)
            # msg['To'] = formataddr(["", self.toaddrs])
            # 邮件主题
            msg['Subject'] = self.title

            # 邮件正文内容
            msg.attach(MIMEText(self.content, 'plain', 'utf-8'))

            # 多个附件
            for file_name in file_list:
                # print("file_name",file_name)
                # 构造附件
                xlsxpart = MIMEApplication(open(file_name, 'rb').read())
                # filename表示邮件中显示的附件名
                xlsxpart.add_header('Content-Disposition',
                                    'attachment', filename='%s' % file_name)
                msg.attach(xlsxpart)

            # SMTP服务器
            server = smtplib.SMTP_SSL("smtp.qiye.163.com", 994, timeout=10)
            # 登录账户
            server.login(self.fromaddr, self.smtp_password)
            # 发送邮件
            server.sendmail(self.fromaddr, self.toaddrs +
                            self.ccaddrs, msg.as_string())
            #server.sendmail(self.fromaddr, [self.toaddrs, ], msg.as_string())
            # 退出账户
            server.quit()
            return True
        except Exception as e:
            print(e)
            return False


if __name__ == '__main__':
    # toaddrs
    toaddrs = ['mail1', 'mail2']
    # carbon copy
    ccaddrs = ['mail1', ]
    # 标题
    title = "your title"
    # 发送内容
    content = "your content"
    # 附件列表
    file_list = ["file1", "file2"]
    sendmymail = SendMail(toaddrs, ccaddrs, title, content).send(file_list)
    # print(sendmymail, type(sendmymail))
