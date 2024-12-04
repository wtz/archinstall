#!/bin/bash
clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "by Stephan Raabe (2023)"
echo "-----------------------------------------------------"
echo ""
echo "Important: Please make sure that you have followed the "
echo "manual steps in the README to partition the harddisc!"
echo "Warning: Run this script at your own risk."
echo ""

# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
# lsblk
# read -p "Enter the name of the EFI partition (eg. sda1): " sda1
# read -p "Enter the name of the ROOT partition (eg. sda2): " sda2
# read -p "Enter the name of the VM partition (keep it empty if not required): " sda3

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
timedatectl set-ntp true

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
mkfs.fat -F 32 /dev/sda1
mkfs.btrfs -f /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3


# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
mount /dev/sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt

mount -o compress=zstd:1,noatime,subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/{boot/efi,boot/grub,home,.snapshots,var/{cache,log}}
mount -o compress=zstd:1,discard=async,noatime,subvol=@cache /dev/sda2 /mnt/var/cache
mount -o compress=zstd:1,discard=async,noatime,subvol=@home /dev/sda2 /mnt/home
mount -o compress=zstd:1,discard=async,noatime,subvol=@log /dev/sda2 /mnt/var/log
mount -o compress=zstd:1,discard=async,noatime,subvol=@snapshots /dev/sda2 /mnt/.snapshots
mount /dev/sda1 /mnt/boot/efi
# mkdir /mnt/vm
# mount /dev/$sda3 /mnt/vm

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap -K /mnt base base-devel git linux linux-firmware vim openssh rsync intel-ucode

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
cp 2-configuration.sh /mnt/archinstall/
cp 3-yay.sh /mnt/archinstall/
cp 4-zram.sh /mnt/archinstall/
cp 5-timeshift.sh /mnt/archinstall/
cp 6-preload.sh /mnt/archinstall/
cp snapshot.sh /mnt/archinstall/

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
#arch-chroot /mnt ./archinstall/2-configuration.sh （这一步，要改下手动执行2-configuration.sh）
arch-chroot /mnt

