`https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/consistent-network-interface-device-naming_configuring-and-managing-networking`

If consistent device naming is enabled, which is the default in Red Hat Enterprise Linux 8, the udev device manager generates device names based on the following schemes:

```
1

Device names incorporate firmware or BIOS-provided index numbers for onboard devices. If this information is not available or applicable, udev uses scheme 2.

eno1

2

Device names incorporate firmware or BIOS-provided PCI Express (PCIe) hot plug slot index numbers. If this information is not available or applicable, udev uses scheme 3.

ens1

3

Device names incorporate the physical location of the connector of the hardware. If this information is not available or applicable, udev uses scheme 5.

enp2s0

4

Device names incorporate the MAC address. Red Hat Enterprise Linux does not use this scheme by default, but administrators can optionally use it.

enx525400d5e0fb

5

The traditional unpredictable kernel naming scheme. If udev cannot apply any of the other schemes, the device manager uses this scheme.

eth0
```  
By default, Red Hat Enterprise Linux selects the device name based on the NamePolicy setting in the /usr/lib/systemd/network/99-default.link file. The order of the values in NamePolicy is important. Red Hat Enterprise Linux uses the first device name that is both specified in the file and that udev generated.  

If you manually configured udev rules to change the name of kernel devices, those rules take precedence.  