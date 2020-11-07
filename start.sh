pacstrap_pkgs = (
    "base",
    "linux-firmware",
    "linux-lts",
    "linux-lts-headers",
    "vim",
    "git"
)

read -p 'boot partition name: ' $boot_part
read -p 'root partition name: ' $root_part
read -sp 'root password: ' $root_pass
read -p 'user name: ' $user
read -sp '$user password: ' $user_pass

timedatectl set-ntp true

pacstrap /mnt ${pacstrap_pkgs[*]} # installs all required packages

genfstab -U /mnt >> /mnt/etc/fstab

cp install.sh /mnt/install.sh
arch-chroot /mnt /install.sh
rm /mnt/install.sh

umount -R /mnt
reboot
