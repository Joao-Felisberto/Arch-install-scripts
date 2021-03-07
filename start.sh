#! /bin/bash

declare -a pkg
while read ln
do
  pkg+="$ln "
done < "packages.install"

read -p "boot partition name: " boot_part
read -p "root partition name: " root_part
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
mkfs.vfat -F 32 "$boot_part"
mount "$root_part" /mnt
mkdir /mnt/boot
mkdir /mnt/boot/EFI
mount "$boot_part" /mnt/boot/EFI

pacstrap /mnt ${pkg[*]} grub efibootmgr # installs all required packages

genfstab -U /mnt >> /mnt/etc/fstab

cp services.install /mnt/services.install
cp install.sh /mnt/install.sh
arch-chroot /mnt /bin/bash /install.sh $root_pass $user $user_pass $hostname
rm /mnt/install.sh
rm /mnt/services.install

# dotfiles
git clone https://github.com/Joao-Felisberto/dotfiles.git "/mnt/home/$user/.config"
cp -r "/mnt/home/$user/.config/stuff/." "/mnt/home/$user/"

umount -R /mnt
reboot
