declare -a pacstrap_pkgs
input = "packages.install"
while read line
do
  cfg += line
done < "$input"

read -p "boot partition name: " $boot_part
read -p "root partition name: " $root_part
read -sp "root password: " $root_pass
read -p "user name: " $user
read -sp "$user password: " $user_pass
read -p "hostname: " $hostname

#touch install-config.cfg
#echo "\n$boot_part" >> install-config.cfg
#echo "\n$root_part" >> install-config.cfg
#echo "\n$root_pass" >> install-config.cfg
#echo "\n$user" >> install-config.cfg
#echo "\n$user_pass" >> install-config.cfg
#echo "\n$hostname" >> install-config.cfg

timedatectl set-ntp true

mkfs.ext4 $root_part
mkfs.fat -F32 $boot_part
mount /mnt $root_part
mkdir /mnt/boot
mkdir /mnt/boot/EFI
mount /mnt/boot/EFI $boot_part

pacstrap /mnt ${pacstrap_pkgs[*]} # installs all required packages

genfstab -U /mnt >> /mnt/etc/fstab

cp install.sh /mnt/install.sh
#cp install-config.cfg /mnt/install-config.cfg
arch-chroot /mnt /install.sh $root_pass $user $user_pass $hostname
rm /mnt/install.sh
#rm /mnt/install-config.cfg

umount -R /mnt
reboot
