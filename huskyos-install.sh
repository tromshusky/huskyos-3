#!/bin/sh
set -euo pipefail

echo todo: need to replace nixos-install with nix build and create efibootmgr entries; exit 1;

ghroot=tromshusky/huskyos-3/main
defaultflake=https://raw.githubusercontent.com/$ghroot/etc-huskyos/flake.nix


which >/dev/null 2>/dev/null mkpasswd curl mkfs.fat parted nixos-install nixos-generate-config btrfs mkfs.btrfs ||
  export PATH=$(nix-shell -p mkpasswd curl dosfstools parted nixos-install-tools btrfs-progs --run "echo \$PATH") || {
    echo >&2 "couldn't donwload missing programs";
    exit 1;
  }

# assertions

cond_root(){ [ $EUID -eq 0 ]; }
cond_diskpar(){ [ -v HUSKYOS_INSTALL_DISK ]; }
cond_diskexs(){ lsblk "$HUSKYOS_INSTALL_DISK" >/dev/null; }

cond_root || echo >&2 "please run as root"
cond_diskpar && {
  cond_diskexs || echo >&2 "$HUSKYOS_INSTALL_DISK is not a disk";
} || echo >&2 "HUSKYOS_INSTALL_DISK is not set"

cond_diskpar || exit 1
cond_diskexs || exit 1
cond_root || exit 1

# variables

PART_SUFFIX=$([[ $HUSKYOS_INSTALL_DISK =~ [0-9]$ ]] && echo p || echo "")

# execution

[ -v HUSKYOS_ROOT_PW ] || echo HUSKYOS_ROOT_PW not set
[ -v HUSKYOS_KBD_LAYOUT ] || echo HUSKYOS_KBD_LAYOUT not set
mkdir -p /mnt
mount -t tmpfs tmpfs /mnt
chmod 0755 /mnt
mkdir -p /mnt/etc/huskyos
curl $defaultflake > /mnt/etc/huskyos/flake.nix

while read dev mp rest; do
    case "$dev" in
        "$HUSKYOS_INSTALL_DISK"*)
            umount -q "$mp" || {
                echo "Error: Failed to unmount $mp with $dev" >&2
                exit 1
            }
            ;;
    esac
done < /proc/self/mounts

parted $HUSKYOS_INSTALL_DISK --script mklabel gpt
parted $HUSKYOS_INSTALL_DISK --script mkpart EFI fat32 0% 4GiB set 1 esp on mkpart BTR btrfs 4GiB 100%

EFI=${HUSKYOS_INSTALL_DISK}${PART_SUFFIX}1
BTR=${HUSKYOS_INSTALL_DISK}${PART_SUFFIX}2

mkfs.fat -F 32 $EFI
mkfs.btrfs -q -f $BTR

mkdir /mnt/btr /mnt/nix /mnt/boot /mnt/systemdata /mnt/userdata

mount -o subvol=/ $BTR /mnt/btr
btrfs subvolume create /mnt/btr/@huskyos
btrfs subvolume create /mnt/btr/@huskyos/@userdata /mnt/btr/@huskyos/@systemdata /mnt/btr/@huskyos/@nix

mount $EFI /mnt/boot
mount $BTR -o subvol=@huskyos/@nix /mnt/nix
mount $BTR -o subvol=@huskyos/@userdata /mnt/userdata
mount $BTR -o subvol=@huskyos/@systemdata /mnt/systemdata

nixos-generate-config --show-hardware-config --no-filesystems > /mnt/etc/huskyos/hardware-configuration.nix
printf $EFI > /mnt/etc/huskyos/EFI
printf $BTR > /mnt/etc/huskyos/BTR
[ -v HUSKYOS_ROOT_PW ] && mkpasswd -m SHA-512 "$HUSKYOS_ROOT_PW" > /mnt/etc/huskyos/RPW
[ -v HUSKYOS_KBD_LAYOUT ] && printf "$HUSKYOS_KBD_LAYOUT" > /mnt/etc/huskyos/KBD

mkdir -p /mnt/boot/efi/boot/
# nixos-install --no-root-password --flake /mnt/etc/huskyos#huskyos
cp /mnt$(nix build --extra-experimental-features "nix-command flakes" /mnt/etc/huskyos#nixosConfigurations.huskyos.config.system.build.uki --no-link --print-out-paths --no-write-lock-file --store /mnt)/nixos.efi /mnt/boot/efi/boot/BOOTX64.EFI
