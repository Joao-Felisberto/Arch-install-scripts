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

usermod --append --groups wheel $2
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

if [ -s aur.install ]
then
	sudo -u "$2" mkdir -p /home/$2/Programs/
	cd "/home/$2/Programs/"

	sudo -u "$2" git clone https://aur.archlinux.org/pikaur.git
	cd pikaur
	sudo -u "$2" makepkg -fsri

	pks=""
	while read ln; do
		pks="$pks $ln"	
	done < "/aur.install"

	sudo -u "$2" pikaur -S $pks --noconfirm
	cd /
fi

while read ln
do
  systemctl enable "$ln"
done < "services.install"

cd "/home/$2"
sudo -u "$2" echo ".dotfiles" >> .gitignore
sudo -u "$2" git clone --bare https://github.com/Joao-Felisberto/dotfiles "$HOME/.dotfiles"
sudo -u "$2" rm "$HOME/.bashrc" "$HOME/.config/i3/config"
sudo -u "$2" /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" checkout

cd /
grub-install --target=x86_64-efi --efi-directory=/boot/EFI
grub-mkconfig -o /boot/grub/grub.cfg
