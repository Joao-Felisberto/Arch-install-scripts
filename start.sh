#pacstrap_pkgs = (
#    "base",
#    "linux-firmware",
#    "linux-lts",
#    "linux-lts-headers",
#    "vim",
#    "git"
#)

declare -a pacstrap_pkgs
input = "packages.install"
while read line
do
  cfg += line
done < "$input"

read -p 'boot partition name: ' $boot_part
read -p 'root partition name: ' $root_part
read -sp 'root password: ' $root_pass
read -p 'user name: ' $user
read -sp '$user password: ' $user_pass
read -p 'hostname: ' $hostname

touch install-config.cfg
echo "$boot_part" >> install-config.cfg
echo "$root_part" >> install-config.cfg
echo "$root_pass" >> install-config.cfg
echo "$user" >> install-config.cfg
echo "$user_pass" >> install-config.cfg
echo "$hostname" >> install-config.cfg

timedatectl set-ntp true

pacstrap /mnt ${pacstrap_pkgs[*]} # installs all required packages

genfstab -U /mnt >> /mnt/etc/fstab

cp install.sh /mnt/install.sh
cp install-config.cfg /mnt/install-config.cfg
arch-chroot /mnt /install.sh
rm /mnt/install.sh
rm /mnt/install-config.cfg

umount -R /mnt
reboot
