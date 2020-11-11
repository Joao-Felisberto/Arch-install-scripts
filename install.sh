#input="/install-config.cfg"
#declare -a cfg

#while read line
#do
#  cfg += line
#done < "$input"

#	1	2	3	4
#$root_pass $user $user_pass $hostname

ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "KEYMAP=pt-latin1" >> /etc/vconsole.conf

touch /etc/hostname
echo $4 >> /etc/hostname

cat "127.0.0.1	localhost" >> /etc/hosts
cat "::1		localhost" >> /etc/hosts
cat "127.0.1.1	$4.localdomain	$4" >> /etc/hosts

echo $1\n$1| passwd

useradd -m $2
echo $3\n$3| passwd