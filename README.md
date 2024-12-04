# Arch Install Script with btrfs for Timeshift or snapper

This is a bash based Arch Linux installation script with EFI boot loader and btrfs partition prepared for Timeshift or snapper.

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
# 用gdisk 工具先创建分区1即为/dev/sda1，分配500MB容量；
# 然后创建分区3 /dev/sda3 分配 2G （用户虚拟内存）
# 最后创建分区2 /dev/sda2  剩下空间 放系统的

# 更新镜像
vim /etc/pacman.d/mirrlist
# 搜索 /China  找一个中国的镜像源 放到最前面 然后保存

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

#如果网络原因无法访问github，clone下来，可以安装wget 和 unzip
#然后在局域网的另外一台电脑下载，将相关文件搞成zip，在另外一台电脑上起个nodeserver
#然后通过wget下载即可


cd archinstall

# Start the script
./1-install.sh

# 1-install.sh 命令执行成功后，在手动执行： 
sh ./2-configuration.sh 

```

## Additional information

Please note that the scripts in folder /optional are not tested yet.

After the installation you will find additional scripts in your home folder to install

- yay aur helper
- timeshift snapshots
- preload application cache

Please also check out the dotfiles to configure qtile and several other applications.


# 备份
首先运行 pacman -Qe，这个命令可以列出系统中所有手动指定安装的包，运行 pacman -Qe >> list.txt 可以将这个软件包名单保存到 list.txt 文件里面，再将这个文件保存到方便查看的地方，比如自己的手机里什么的，方便重装后参照这个名单将软件装回来。

之后是备份整个家目录，以便重装完后恢复绝大多数的个人数据。我找到一个闲置的空的移动硬盘，不是空的也没关系，只要剩余空间够放下家目录的内容就行，将其挂载在 /mnt 目录下，并新建一个空文件夹 backup。为了在恢复数据时保留所有文件的权限，我使用 rsync 命令：

sudo rsync -avrh --progress /home/ /mnt/backup/
这个命令会将所有家目录中的文件同步至 /mnt/backup/ 路径下。选项 -avrh 可以在复制时保留文件的权限，/home/ 是需要备份的目录，/mnt/backup/ 是备份的目标目录，一定要注意路径最后的斜杠，路径最后是否有斜杠对于 rsync 命令来说是完全不同的两个路径，这里在路径最后加上了斜杠，之后再用 rsync 恢复数据时也需要在路径后面加上斜杠。

可以参照https://sspai.com/post/78916 这篇文章


-------
如果以btrf 文件系统安装不成功的话，改成ext4文件系统试下！


# 关于USB烧录成系统盘后无法在win系统下识别解决办法： 
1. 将u盘插入系统；
2. 打开cmd 输入： diskpart
3. 找到U盘符，执行 select disk xx （xx为你U盘的）
4. 执行clean 即可；
5. 然后在磁盘管理器找到U盘，新建简单卷 即可；
6. 然后系统就可以对它进行格式化了；



