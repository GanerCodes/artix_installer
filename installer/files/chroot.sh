set -e

printf "en_US.UTF-8 UTF-8\n"   >> /etc/locale.gen
printf "LANG=en_US.UTF-8\n"     > /etc/locale.conf
printf "KEYMAP=us\n"            > /etc/vconsole.conf
printf "server\n"               > /etc/hostname
printf "hostname=\"server\"\n"  > /etc/conf.d/hostname
printf "\n127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tserver.localdomain\tserver\n" > /etc/hosts
ln -sf /usr/share/zoneinfo/$region_city /etc/localtime
locale-gen
hwclock --systohc

useradd admin
yes       "root" | passwd root # obviously don't enable ssh for root
yes "$adminpass" | passwd admin

root_uuid=$(blkid "$root_part" -o value -s UUID)
kprams=$(echo "root=UUID=$root_uuid nomodeset" | sed 's/\//\\\//g')
if [[ $encrypted == "y" ]]; then
    kprams="cryptdevice=UUID=$root_uuid:root root=$kprams"
    sed -i '/GRUB_ENABLE_CRYPTODISK=y/s/^#//g' /etc/default/grub
fi

sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT.*$/GRUB_CMDLINE_LINUX_DEFAULT=\"$kprams\"/g" /etc/default/grub
if [[ $EFI ]]; then
    grub-install --target=x86_64-efi --efi-directory=/boot --force "$my_disk" --bootloader-id=GRUB
else
    grub-install $my_disk
fi
grub-mkconfig -o /boot/grub/grub.cfg

HOOKS="base udev autodetect keyboard keymap modconf block filesystems fsck"
if [[ $my_disk == *"nvme"* ]]; then HOOKS="$HOOKS nvme";    fi
if [[ $encrypted == "y" ]];    then HOOKS="$HOOKS encrypt"; fi
sed -i "s/^HOOKS.*$/HOOKS=($HOOKS)/g" /etc/mkinitcpio.conf

mkinitcpio -P

exec bash /home/admin/Configs/Scripts/prepare_system