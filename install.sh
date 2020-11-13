#! /bin/bash
#	1	2	3	4
#$root_pass $user $user_pass $hostname

ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "KEYMAP=pt-latin1" >> /etc/vconsole.conf

touch /etc/hostname
echo $4 >> /etc/hostname

echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	$4.localdomain	$4" >> /etc/hosts

echo root $1| passwd

useradd -m $2
echo $2 $3| passwd
