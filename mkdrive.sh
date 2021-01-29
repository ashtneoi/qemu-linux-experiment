#!/usr/bin/env bash
set -eu

if [[ -e drive.raw ]]; then
    echo >&2 "error: refusing to overwrite drive.raw"
    exit 1
fi

truncate -s$((4*1024 + 100))k drive.raw
parted -s drive.raw -- unit kiB mklabel gpt
parted -s drive.raw -- unit kiB mkpart root ext4 1MiB 4MiB

rm -f root.ext4
# Small partitions default to an inode size of 128 bytes, which forces narrow
# timestamps that can't go beyond year 2038. 256 bytes is good until 2446.
mkfs.ext4 -d root -I 256 root.ext4 3M

dd bs=1024 if=root.ext4 conv=sparse,notrunc seek=1k of=drive.raw
