dd if=/dev/zero of=$my_disk bs=512 count=1

printf ",1G,0x0c,*\n,${swap_size}G,0x82\n,,V\n" | sfdisk $my_disk
if [[ $EFI ]]; then
    mkfs.vfat -F32 $boot_part
else    
    mkfs.vfat -F16 $boot_part
fi
mkswap $swap_part
mkfs.ext4 $root_part

if [[ $encrypted == "y" ]]; then
    yes $cryptpass | cryptsetup -q luksFormat $root_part
    yes $cryptpass | cryptsetup open $root_part root
fi

mkdir -p /mnt/artix/
mount $root_part /mnt/artix
mkdir -p /mnt/artix/boot
mount $boot_part /mnt/artix/boot

packs=""
[[ $(grep 'vendor' /proc/cpuinfo) == *"Intel"* ]] && packs="intel-ucode"
[[ $(grep 'vendor' /proc/cpuinfo) == *"Amd"* ]] && packs="amd-ucode"
[[ $encrypted == "y" ]] && packs+=" cryptsetup cryptsetup-openrc"

basestrap /mnt/artix base base-devel linux linux-firmware linux-headers mkinitcpio openrc elogind-openrc efibootmgr grub dhcpcd wpa_supplicant connman-openrc $packs
fstabgen -U /mnt/artix > /mnt/artix/etc/fstab