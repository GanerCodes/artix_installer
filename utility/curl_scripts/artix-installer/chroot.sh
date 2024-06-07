printf "en_US.UTF-8 UTF-8\n" >> /etc/locale.gen
printf "LANG=en_US.UTF-8\n" > /etc/locale.conf
printf "KEYMAP=us\n" > /etc/vconsole.conf
printf "server\n" > /etc/hostname
printf "hostname=\"server\"\n" > /etc/conf.d/hostname
printf "\n127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tserver.localdomain\tserver\n" > /etc/hosts
printf "nameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver 127.0.0.1\n"
ln -sf /usr/share/zoneinfo/$region_city /etc/localtime
locale-gen
hwclock --systohc

my_params="root=$root_part nomodeset"
my_params=$(echo "$my_params" | sed 's/\//\\\//g')
if [[ $encrypted == "y" ]]; then
    root_uuid=$(blkid $root_part -o value -s UUID)
    my_params="cryptdevice=UUID=$(echo $root_uuid):root root=$(echo $my_params)"
    sed -i '/GRUB_ENABLE_CRYPTODISK=y/s/^#//g' /etc/default/grub
fi

sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT.*$/GRUB_CMDLINE_LINUX_DEFAULT=\"$my_params\"/g" /etc/default/grub
if [[ $EFI ]]; then
    grub-install --target=x86_64-efi --efi-directory=/boot --recheck
else
    grub-install $my_disk
fi
grub-mkconfig -o /boot/grub/grub.cfg

yes $root_password | passwd
sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers

printf "\n$swap_part\t\tswap\t\tswap\t\tsw\t0 0\n" >> /etc/fstab

if [[ $encrypted == "y" ]]; then
    sed -i 's/^HOOKS.*$/HOOKS=(base udev autodetect keyboard keymap modconf block filesystems fsck nvme encrypt)/g' /etc/mkinitcpio.conf
else
    sed -i 's/^HOOKS.*$/HOOKS=(base udev autodetect keyboard keymap modconf block filesystems fsck nvme)/g' /etc/mkinitcpio.conf
fi
mkinitcpio -P