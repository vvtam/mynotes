# _*_ coding:utf-8 _*_
# python3
# netaddr https://netaddr.readthedocs.io/en/latest/#
# ip range to CIDR

import netaddr
import sys
import re


def main():
    fname = sys.argv[1]
    with open(fname, 'r') as f:
        ls = f.readlines()
        for i in ls:
            # i = i.strip().split(' ')
            i = re.split(',|-|;|:| ', i.strip())
            startip = i[0]
            endip = i[1]
            cidrs = netaddr.iprange_to_cidrs(startip, endip)
            for k, v in enumerate(cidrs):
                ipmask = v
                ipmask = str(ipmask)
                open('cidrs_' + fname, 'a+').write(ipmask + '\n')


if __name__ == '__main__':
    main()
