#Kindle资源
##JailBreak and UsbNet
http://www.mobileread.com/forums/showthread.php?t=186645
##Python
http://www.mobileread.com/forums/showthread.php?t=195474
##KUAL
http://www.mobileread.com/forums/showthread.php?t=203326
##LinkFronts（Fonts Hack）
http://www.mobileread.com/forums/showthread.php?t=219405

```
参考：https://xmercury.net/kindle-paperwhite-2-override-chinese-fonts/
注意：这种方法不会改变字体菜单中的显示，只是override系统中的现有的中文字体

1. 首先越狱你的Kindle: JailBreak
2. 安装 Python hack & KUAL
3. 安装 fonts hack
4. 把kindle连接电脑，把想替换的字体放到 linkfonts/fonts
5. 参考文件 linkfonts/etc/fc-override.tpl 修改后保存到 linkfonts/etc/conf.d/*.conf, 文件名随意 (比如 100-override-chinese.conf), 但是文件后缀需要是 .conf
文件中的%TO_OVERRIDE%替换成STSong, STKai, Mying Hei S, STYuan 中的一个(分别对应系统字体中的 宋体, 楷体, 黑体, 圆体)
%TO_USE% 改成要使用的字体的字体名称 (注意不是ttf文件的文件名)
6. Eject, (看不懂这步的去看第二步KUAL里的说明)
  1. KUAL > Fonts > Fonts Hack Behavior > Update fontconfig cache
  2. KUAL > Fonts > Restart framework
7. Enjoy
已知问题：替换宋体或黑体貌似会让英文字体也被替换掉，如果你只看中文书问题不大；如果只是替换楷体或圆体是不影响英文字体的
```

##字体推荐
`参考：https://blog.xjpvictor.info/2014/02/kindle-advanced-dictionary/`
- 方正宋体-超大字符集-加粗版
- 花园明朝体A-修改中文版
- 花园明朝体B-修改中文版

##词典推荐
- 汉典
- 汉语大辞典