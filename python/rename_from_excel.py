#!/usr/bin/env python2

# -*- coding: utf-8 -*-

import xlrd
import os
# import shutil

path_r = "/home/"
xlsname = "tmp.xls"
# excel文件
bk = xlrd.open_workbook(xlsname)
# open the excel file
#shxrange = range(bk.nsheets)
try:
    sh = bk.sheet_by_name("Sheet1")
    # set sheet name
except:
    print "no sheet in %s named Sheet1" % xlsname
nrows = sh.nrows
# rows
ncols = sh.ncols
# cols
print "nrows %d, ncols %d" % (nrows, ncols)
# cell_value = sh.cell_value(0,0)
# get the value of x row and y col
# print cell_value
# path_file = os.path.split(cell_value)
# split the dir and the filename
# print path_file
# cwd_dir = os.getcwd()
# print cwd_dir
# exit()
for num_rows in range(0, nrows):
    old_name = sh.cell_value(num_rows, 0)
    # 第一列是旧目录
    new_name = sh.cell_value(num_rows, 1)
    # 第二列是新目录
    # old_name = unicode(old_name, 'utf8')
    # new_name = unicode(new_name, 'utf8')
    print "%s > %s" % (old_name, new_name)
    # exit()
    os.renames(path_r + old_name, path_r + new_name)
    # 组合绝对路径
    # shutil.copytree(path_r + old_name.encode('utf8'), path_r + new_name.encode('utf8'))
