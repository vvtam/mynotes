## OTA update

OTA下载

[Full OTA Images for Nexus and Pixel Devices  | Google Play services  | Google Developers](https://developers.google.com/android/ota)

```
adb reboot recovery
adb devices
adb sideload ota-file.zip
```

Factory images下载

[Factory Images for Nexus and Pixel Devices  | Google Play services  | Google Developers](https://developers.google.com/android/images#coral)



## Root

下载magisk canary版本，现在支持12

https://raw.githubusercontent.com/topjohnwu/magisk-files/canary/app-debug.apk

从Factory images 提取boot.img 传输到手机，打开magisk修补boot.img

修补过的boot_patched.img传输到本地，adb安装

```
adb reboot bootloader
fastboot flash boot magisk_patched.img
fastboot reboot
```

重启后已经root

## 打开motion sense

```
adb shell
su root
setprop pixel.oslo.allowed_override 1
setprop persist.pixel.oslo.allowed_override 1
setprop ctl.restart zygote
```
