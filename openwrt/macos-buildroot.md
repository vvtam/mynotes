#MacOS buildroot#

https://wiki.openwrt.org/doc/howto/buildroot.exigence.macosx

These instructions worked on OS X 10.12.3 on 15 Feb 2017.

1.Install Xcode or at least Xcode command line tools from the MacOSX App Store

2.[Install brew](https://brew.sh/).

3.Add duplicates repository to homebrew for grep formulae:
`brew tap homebrew/dupes`

4.Install additional formulae:
`brew install coreutils findutils gawk gnu-getopt gnu-tar grep wget quilt xz`

5.gnu-getopt is keg-only, so force linking it:
`brew ln gnu-getopt --force`

6.To get rid of "date illegal option" you can add to your .bash_profile:
`PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"`

7.OS X by default comes with a case-insensitive filesystem. OpenWrt won't build on that. As a workaround, create a (Sparse) case-sensitive disk-image that you then mount in the finder and use as build directory:
```
hdiutil create -size 20g -type SPARSE -fs "Case-sensitive HFS+" -volname OpenWrt OpenWrt.sparseimage
hdiutil attach OpenWrt.sparseimage
```
8.Change to
`cd /Volumes/OpenWrt`

(Your newly created and mounted disk image)

9.Now proceed normally (git clone…)
