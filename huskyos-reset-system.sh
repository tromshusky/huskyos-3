#!/usr/bin/env -S /bin/sh -c 'export PATH=/run/current-system/sw/bin; cat $0 | unshare -m'

set -eu

A=A
B=B
sys=@systemdata
hosub=@huskyos
tmpdir=/tmp
tmpho=/tmp/huskyos
thsys=/tmp/huskyos/@systemdata

BTR=$(cat /etc/huskyos/BTR)
[ -n "$BTR" ] || { echo >&2 Error: /etc/huskyos/BTR is not valid; exit 1; }

mkdir -p $tmpdir &&
mount -t tmpfs tmpfs $tmpdir &&
mkdir -p $tmpho &&
mount $BTR -o subvol=$hosub $tmpho &&
test -h $thsys || exit 1;
RP=$(realpath $thsys) &&
NEXT=$([ "$RP" == $thsys-$A ] && echo $B || echo $A) &&
btrfs subvolume delete $thsys-$NEXT || true;
test -e $thsys-$NEXT && { echo >&2 Error: could not delete subvolume $sys-$NEXT; exit 1; } ||
btrfs subvolume create $thsys-$NEXT &&
ln -snf $sys-$NEXT $thsys &&
set +u && exit 0 ||
set +u && exit 1;
