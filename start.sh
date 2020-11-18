#! /bin/bash

declare -a cfg
while read ln
do
  cfg+="$ln "
done < "packages.install"

read -p "boot partition name: " boot_part
read -p "root partition name: " root_part
read -sp "root password: " root_pass
echo " "
read -p "user name: " user
read -sp "password for $user: " user_pass
echo " "
read -p "hostname: " hostname

timedatectl set-ntp true

mkfs.ext4 "$root_part"
mkfs.vfat -F 32 "$boot_part"
mount "$root_part" /mnt
mkdir /mnt/boot
mkdir /mnt/boot/EFI
mount "$boot_part" /mnt/boot/EFI

pacstrap /mnt ${cfg[*]} grub efibootmgr # installs all required packages

genfstab -U /mnt >> /mnt/etc/fstab

cp install.sh /mnt/install.sh
arch-chroot /mnt /bin/bash /install.sh $root_pass $user $user_pass $hostname
rm /mnt/install.sh

umount -R /mnt
reboot
