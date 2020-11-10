input="/install-config.cfg"
declare -a cfg

while read line
do
  cfg += line
done < "$input"

ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "KEYMAP=pt-latin1" >> /etc/vconsole.conf

touch /etc/hostname
echo ${cfg[5]} >> /etc/hostname

cat "127.0.0.1	localhost" >> /etc/hosts
cat "::1		localhost" >> /etc/hosts
cat "127.0.1.1	${cfg[5]}.localdomain	${cfg[5]}" >> /etc/hosts

echo ${cfg[2]}\n${cfg[2]}| passwd

useradd -m ${cfg[3]}
echo ${cfg[4]}\n${cfg[4]}| passwd
