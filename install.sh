#! /bin/bash
# 1         2     3          4
#$root_pass $user $user_pass $hostname

ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "KEYMAP=pt-latin1" >> /etc/vconsole.conf

touch /etc/hostname
echo $4 > /etc/hostname

echo "127.0.0.1	localhost" > /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	$4.localdomain	$4" >> /etc/hosts

echo "root:$1" | chpasswd

useradd -m $2
echo "$2:$3" | chpasswd

if [ -s aur.install ]
then
	mkdir -p "/home/$2/Programs/"
	cd "/home/$2/Programs/"
	git clone https://aur.archlinux.org/pikaur.git
	cd pikaur
	makepkg -fsri

	while read ln
	do
		pikaur -S "$ln" --no-confirm
	done < "aur.install"

	cd /
fi

while read ln
do
  systemctl enable "$ln"
done < "services.install"

grub-install --target=x86_64-efi --efi-directory=/boot/EFI
grub-mkconfig -o /boot/grub/grub.cfg
