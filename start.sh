declare -a cfg
while read line
do
  cfg+="$ln "
done < "packages.install"

read -p "boot partition name: " boot_part
read -p "root partition name: " root_part
read -sp "root password: " root_pass
read -p "user name: " user
read -sp '$user password: ' user_pass
read -p "hostname: " hostname

timedatectl set-ntp true

mkfs.ext4 '$root_part'
mkfs.vfat -F 32 '$boot_part'
mount /mnt '$root_part'
mkdir /mnt/boot
mkdir /mnt/boot/EFI
mount /mnt/boot/EFI '$boot_part'

pacstrap /mnt ${pacstrap_pkgs[*]} # installs all required packages

genfstab -U /mnt >> /mnt/etc/fstab

cp install.sh /mnt/install.sh
arch-chroot /mnt /install.sh $root_pass $user $user_pass $hostname
rm /mnt/install.sh

umount -R /mnt
reboot
