#! /bin/bash

declare -a pkg
while read ln
do
  pkg+="$ln "
done < "packages.install"

read -p "boot partition name: " boot_part
read -p "root partition name: " root_part
read -p "with home? [y/N]: " has_home
if [ "$has_home" = "y" ]; then read -p "home partition name: " home_part; fi
read -p "with swap? [y/N]: " has_swap
if [ "$has_swap" = "y" ]; then read -p "swap partition name: " swap_part; fi
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
if [ "$has_home" = "y" ]; then mkfs.ext4 "$home_part"; fi
mkfs.vfat -F 32 "$boot_part"

mount "$root_part" /mnt

mkdir /mnt/boot
mkdir /mnt/boot/EFI
mount "$boot_part" /mnt/boot/EFI

if [ "$has_home" = "y" ]
then 
	mkdir /mnt/home
	mount "$home_part" /mnt/home
fi

if [ "$has_swap" = "y" ]
then 
	mkswap "$swap_part"
	swapon "$swap_part"
fi

pacstrap /mnt ${pkg[*]} grub efibootmgr # installs all required packages

genfstab -U /mnt >> /mnt/etc/fstab

cp services.install /mnt/services.install
cp aur.install /mnt/aur.install
cp install.sh /mnt/install.sh
arch-chroot /mnt /bin/bash /install.sh $root_pass $user $user_pass $hostname
rm /mnt/install.sh
rm /mnt/aur.install
rm /mnt/services.install

#umount -R /mnt
#reboot
