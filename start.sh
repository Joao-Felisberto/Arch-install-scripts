#! /bin/bash

declare -a pkg
while read ln
do
  pkg+="$ln "
done < "packages.install"

read -p "boot partition name: " boot_part
read -p "root partition name: " root_part
read -p "home partition name: " home_part
read -sp "root password: " root_pass
echo " "
read -p "user name: " user
read -sp "password for $user: " user_pass
echo " "
read -p "hostname: " hostname

# PARA OS DOTFILES
#https://www.tutorialkart.com/bash-shell-scripting/bash-split-string/

timedatectl set-ntp true

mkfs.ext4 "$root_part"
mkfs.ext4 "$home_part"
mkfs.vfat -F 32 "$boot_part"

mount "$root_part" /mnt

mkdir /mnt/boot
mkdir /mnt/boot/EFI
mount "$boot_part" /mnt/boot/EFI

mkdir /mnt/home
mount "$home_part" /mnt/home

pacstrap /mnt ${pkg[*]} grub efibootmgr # installs all required packages

genfstab -U /mnt >> /mnt/etc/fstab

cp services.install /mnt/services.install
cp install.sh /mnt/install.sh
arch-chroot /mnt /bin/bash /install.sh $root_pass $user $user_pass $hostname
rm /mnt/install.sh
rm /mnt/services.install

umount -R /mnt
reboot
