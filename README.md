# Arch Install Script with btrfs for Timeshift or snapper

This is a bash based Arch Linux installation script with EFI boot loader and btrfs partition prepared for Timeshift or snapper.

[![Watch on YouTube](https://img.youtube.com/vi/uskzgcyGAOE/0.jpg)](https://www.youtube.com/watch?v=uskzgcyGAOE)

Install Arch Linux YOUR WAY. Arch Linux Installation 2023
https://youtu.be/uskzgcyGAOE

## Getting started

To make it easy for you to get started, here's a list of recommended next steps. 
The script will ask for some information during the installation but is not performing any validation check so far.
To get detailed information how to install Arch Linux, please visit https://wiki.archlinux.org/title/installation_guide


```
# Increase font size (optional)
setfont ter-p20b

# Connect to WLAN (if not LAN)
iwctl --passphrase [password] station wlan0 connect [network]

# Check internet connection
ping -c4 www.archlinux.org

# Check partitions
lsblk

# Create partitions
gdisk /dev/sda
# Partition 1: +512M ef00 (for EFI)
# Partition 3: +2G (for swap)
# Partition 2: Available space 8300 (for Linux filesystem)
# Write w, Confirm Y

# Sync package
pacman -Syy

# Maybe it's required to install the current archlinux keyring
# if the installation of git fails.
pacman -S archlinux-keyring
pacman -Syy

# Install git
pacman -S git

# Clone Installation
git clone https://github.com/wtz/archinstall.git
cd archinstall

# Start the script
./1-install.sh

```

## Additional information

Please note that the scripts in folder /optional are not tested yet.

After the installation you will find additional scripts in your home folder to install

- yay aur helper
- zram swap file
- timeshift snapshots
- preload application cache

Please also check out the dotfiles to configure qtile and several other applications.


# 备份
首先运行 pacman -Qe，这个命令可以列出系统中所有手动指定安装的包，运行 pacman -Qe >> list.txt 可以将这个软件包名单保存到 list.txt 文件里面，再将这个文件保存到方便查看的地方，比如自己的手机里什么的，方便重装后参照这个名单将软件装回来。

之后是备份整个家目录，以便重装完后恢复绝大多数的个人数据。我找到一个闲置的空的移动硬盘，不是空的也没关系，只要剩余空间够放下家目录的内容就行，将其挂载在 /mnt 目录下，并新建一个空文件夹 backup。为了在恢复数据时保留所有文件的权限，我使用 rsync 命令：

sudo rsync -avrh --progress /home/ /mnt/backup/
这个命令会将所有家目录中的文件同步至 /mnt/backup/ 路径下。选项 -avrh 可以在复制时保留文件的权限，/home/ 是需要备份的目录，/mnt/backup/ 是备份的目标目录，一定要注意路径最后的斜杠，路径最后是否有斜杠对于 rsync 命令来说是完全不同的两个路径，这里在路径最后加上了斜杠，之后再用 rsync 恢复数据时也需要在路径后面加上斜杠。

可以参照https://sspai.com/post/78916 这篇文章
