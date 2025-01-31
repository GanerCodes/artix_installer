#!/bin/sh
# https://github.com/Zaechus/artix-installer

set -e && cd "$(dirname "$0")"

sudo loadkeys us
confirm_password() {
    local pass1="a"
    local pass2="b"
    until [[ $pass1 == $pass2 && $pass2 ]]; do
        printf "$1: " >&2 && read -rs pass1
        printf "\n" >&2
        printf "confirm $1: " >&2 && read -rs pass2
        printf "\n" >&2
    done
    echo $pass2; }

while :; do
    sudo fdisk -l
    printf "\nDisk to install to (e.g. /dev/sda): " && read my_disk
    [[ -b $my_disk ]] && break
done

if [[ $my_disk == *"nvme"* ]]; then
    boot_part="$my_disk"p1 ; root_part="$my_disk"p2
else
    boot_part="$my_disk"1  ; root_part="$my_disk"2
fi

adminpass=$(confirm_password "admin password")
printf "Encrypt? (y/N): " && read encrypted
[[ ! $encrypted ]] && encrypted="n"
[[ $encrypted == "y" ]] && cryptpass=$(confirm_password "encryption password")

until [[ -f /usr/share/zoneinfo/$region_city ]]; do
    printf "Region/City (Default: America/Chicago): " && read region_city
    [[ ! $region_city ]] && region_city="America/Chicago"
done

[[ -d /sys/firmware/efi ]] && EFI=1
dd if=/dev/zero of=$my_disk bs=512 count=1
printf "label: gpt\n,512M,U\n,,L\n" | sfdisk --no-reread --force $my_disk
[ "$EFI" ] && mkfs.fat -F32 "$boot_part" || mkfs.ext4 -F -F "$boot_part"
mkfs.ext4 -F -F "$root_part"

if [[ $encrypted == "y" ]]; then
    yes $cryptpass | cryptsetup -q luksFormat "$root_part"
    yes $cryptpass | cryptsetup open "$root_part" root
fi

mkdir -p /mnt/artix
mount "$root_part" /mnt/artix
pushd /mnt/artix
    mkdir -p boot proc sys dev run
    mount "$boot_part" boot
    mount --types proc  /proc proc
    mount --rbind       /sys  sys
    mount --make-rslave       sys
    mount --rbind       /dev  dev
    mount --make-rslave       dev
    mount --bind        /run  run
    mount --make-slave        run

    packs=""
    [[ $(grep 'vendor' /proc/cpuinfo) == *"Intel"* ]] && packs+=" intel-ucode"
    [[ $(grep 'vendor' /proc/cpuinfo) == *"Amd"*   ]] && packs+=" amd-ucode"
    [[                     $encrypted ==  "y"      ]] && packs+=" cryptsetup cryptsetup-openrc"
    basestrap /mnt/artix base base-devel linux linux-firmware linux-headers mkinitcpio openrc elogind-openrc efibootmgr grub dhcpcd wpa_supplicant connman-openrc $packs
    fstabgen -U /mnt/artix > /mnt/artix/etc/fstab
popd

echo "Merging stuff into new root…" && sudo cp -R ./files/* /mnt/artix
echo "Chrooting…" && sudo root_part="$root_part" boot_part="$boot_part" my_disk="$my_disk" adminpass="$adminpass" region_city="$region_city" cryptpass="$cryptpass" EFI="$EFI" artix-chroot /mnt/artix /bin/bash -c 'sh /chroot.sh && rm /chroot.sh && echo "Rebooting!" && reboot'