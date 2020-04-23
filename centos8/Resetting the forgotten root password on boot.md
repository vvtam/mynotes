# Resetting the forgotten root password on boot

If you are unable to log in as a non-root user or do not belong to the administrative `wheel` group, you can reset the root password on boot by switching into a specialized `chroot jail` environment.

**Procedure**

1. Reboot the system and, on the GRUB 2 boot screen, press the **e** key to interrupt the boot process.

   The kernel boot parameters appear.

   ```
   load_video
   set gfx_payload=keep
   insmod gzio
   linux ($root)/vmlinuz-4.18.0-80.e18.x86_64 root=/dev/mapper/rhel-root ro crash\
   kernel=auto resume=/dev/mapper/rhel-swap rd.lvm.lv/swap rhab quiet
   initrd ($root)/initramfs-4.18.0-80.e18.x86_64.img $tuned_initrd
   ```

2. Go to the end of the line that starts with **linux**.

   ```
   linux ($root)/vmlinuz-4.18.0-80.e18.x86_64 root=/dev/mapper/rhel-root ro crash\
   kernel=auto resume=/dev/mapper/rhel-swap rd.lvm.lv/swap rhab quiet
   ```

   Press **Ctrl+e** to jump to the end of the line.

3. Add `rd.break` to the end of the line that starts with `linux`.

   ```
   linux ($root)/vmlinuz-4.18.0-80.e18.x86_64 root=/dev/mapper/rhel-root ro crash\
   kernel=auto resume=/dev/mapper/rhel-swap rd.lvm.lv/swap rhab quiet rd.break
   ```

4. Press **Ctrl+x** to start the system with the changed parameters.

   The `switch_root` prompt appears.

5. Remount the file system as writable:

   ```
   mount -o remount,rw /sysroot
   ```

   The file system is mounted as read-only in the `/sysroot` directory. Remounting the file system as writable allows you to change the password.

6. Enter the `chroot` environment:

   ```
   chroot /sysroot
   ```

   The `sh-4.4#` prompt appears.

7. Reset the `root` password:

   ```
   passwd
   ```

   Follow the instructions displayed by the command line to finalize the change of the `root` password.

8. Enable the SELinux relabeling process on the next system boot:

   ```
   touch /.autorelabel
   ```

9. Exit the `chroot` environment:

   ```
   exit
   ```

10. Exit the `switch_root` prompt:

    ```
    exit
    ```

11. Wait until the SELinux relabeling process is finished. Note that relabeling a large disk might take a long time. The system reboots automatically when the process is complete.

[redhat-url](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/managing-user-and-group-accounts_configuring-basic-system-settings#changing-and-resetting-the-root-password-from-the-command-line_managing-user-and-group-accounts)