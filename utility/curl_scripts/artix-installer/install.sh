#!/bin/sh -e
# https://github.com/Zaechus/artix-installer

sudo loadkeys us
# [[ ! -d /sys/firmware/efi ]] && printf "Not booted in UEFI mode. Aborting..." && exit 1

confirm_password () {
    local pass1="a"
    local pass2="b"
    until [[ $pass1 == $pass2 && $pass2 ]]; do
        printf "$1: " >&2 && read -rs pass1
        printf "\n" >&2
        printf "confirm $1: " >&2 && read -rs pass2
        printf "\n" >&2
    done
    echo $pass2
}

while :
do
    sudo fdisk -l
    printf "\nDisk to install to (e.g. /dev/sda): " && read my_disk
    [[ -b $my_disk ]] && break
done
if [[ $my_disk == *"nvme"* ]]; then
    boot_part="$my_disk"p1
    swap_part="$my_disk"p2
    root_part="$my_disk"p3
else
    boot_part="$my_disk"1
    swap_part="$my_disk"2
    root_part="$my_disk"3
fi

until [[ $swap_size =~ ^[0-9]+$ && (($swap_size -gt 0)) && (($swap_size -lt 97)) ]]; do
    printf "Size of swap partition in GiB (4): " && read swap_size
    [[ ! $swap_size ]] && swap_size=4
done

printf "Encrypt? (y/N): " && read encrypted
[[ ! $encrypted ]] && encrypted="n"
[[ $encrypted == "y" ]] && cryptpass=$(confirm_password "encryption password")

root_password=$(confirm_password "root password")

until [[ -f /usr/share/zoneinfo/$region_city ]]; do
    printf "Region/City (e.g. 'America/Chicago'): " && read region_city
    [[ ! $region_city ]] && region_city="America/Chicago"
done

[[ -d /sys/firmware/efi ]] && EFI=1

installvars () {
    echo EFI=$EFI my_disk=$my_disk swap_size=$swap_size boot_part=$boot_part swap_part=$swap_part root_part=$root_part encrypted=$encrypted region_city=$region_city cryptpass=$cryptpass root_password=$root_password
}

sudo $(installvars) sh ./installer.sh
sudo cp ./chroot.sh /mnt/artix/root/
sudo $(installvars) artix-chroot /mnt/artix /bin/bash -c 'sh /root/chroot.sh; rm /root/chroot.sh; exit'

echo "Done. Rebooting in 3 seconds..."
sleep 3
sudo reboot