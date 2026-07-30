#!/usr/bin/env -S /bin/sh -c 'export PATH=/run/current-system/sw/bin; cat $0 | unshare -m'

set -eu

hosub=@huskyos
tmpdir=/tmp
tmpho=/tmp/huskyos

BTR=$(cat /etc/huskyos/BTR)
[ -n "$BTR" ] || { echo >&2 Error: /etc/huskyos/BTR is not valid; exit 1; }

mkdir -p $tmpdir &&
mount -t tmpfs tmpfs $tmpdir &&
mkdir -p $tmpho &&
mount $BTR -o subvol=$hosub $tmpho &&

for subv in @userdata @systemdata; do {
  btrfs subvolume delete $tmpho/$subv{,-*}; 
  btrfs subvolume create $tmpho/$subv;
} & done;

set +u && exit 0 ||
set +u && exit 1;
