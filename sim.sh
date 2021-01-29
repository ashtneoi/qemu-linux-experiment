#!/usr/bin/env bash
set -u

qemu-system-x86_64 -nographic \
    -kernel bzImage \
    -append 'console=uart8250,io,0x3F8 root=/dev/sda1 raid=noautodetect' \
    -drive 'file=drive.raw,format=raw' \
    "$@"
tput init
