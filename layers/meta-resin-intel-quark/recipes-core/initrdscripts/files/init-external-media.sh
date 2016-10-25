#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

ROOT_MOUNT="/mnt/root"
MOUNT="/bin/mount"
UMOUNT="/bin/umount"
ISOLINUX=""
ROOT_DISK="/dev/disk/by-label/flash-root"

# Copied from initramfs-framework. The core of this script probably should be
# turned into initramfs-framework modules to reduce duplication.
udev_daemon() {
  OPTIONS="/sbin/udev/udevd /sbin/udevd /lib/udev/udevd /lib/systemd/systemd-udevd"

  for o in $OPTIONS; do
    if [ -x "$o" ]; then
      echo $o
      return 0
    fi
  done

  return 1
}

_UDEV_DAEMON=`udev_daemon`

early_setup() {
    mkdir -p /proc
    mkdir -p /sys
    mount -t proc proc /proc
    mount -t sysfs sysfs /sys
    mount -t devtmpfs none /dev

    # support modular kernel
    modprobe isofs 2> /dev/null

    mkdir -p /run
    mkdir -p /var/run

    $_UDEV_DAEMON --daemon
    udevadm trigger --action=add
}

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=`cat /proc/cmdline`
    for arg in $CMDLINE; do
        optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
        case $arg in
            root=*)
                ROOT_DEVICE=$optarg ;;
            rootfstype=*)
                modprobe $optarg 2> /dev/null ;;
            LABEL=*)
                label=$optarg ;;
            video=*)
                video_mode=$arg ;;
            vga=*)
                vga_mode=$arg ;;
            console=*)
                if [ -z "${console_params}" ]; then
                    console_params=$arg
                else
                    console_params="$console_params $arg"
                fi ;;
            debugshell*)
                if [ -z "$optarg" ]; then
                        shelltimeout=30
                else
                        shelltimeout=$optarg
                fi
        esac
    done
}

boot_live_root() {
    # Watches the udev event queue, and exits if all current events are handled
    udevadm settle --timeout=3 --quiet
    killall "${_UDEV_DAEMON##*/}" 2>/dev/null

    # Allow for identification of the real root even after boot
    mkdir -p  ${ROOT_MOUNT}
    mount ${ROOT_DISK} ${ROOT_MOUNT}

    # Move the mount points of some filesystems over to
    # the corresponding directories under the real root filesystem.
    for dir in `awk '/\/dev.* \/run\/media/{print $2}' /proc/mounts`; do
        mkdir -p  ${ROOT_MOUNT}/media/${dir##*/}
        mount -n --move $dir ${ROOT_MOUNT}/media/${dir##*/}
    done
    mount -n --move /proc ${ROOT_MOUNT}/proc
    mount -n --move /sys ${ROOT_MOUNT}/sys
    mount -n --move /dev ${ROOT_MOUNT}/dev

    cd $ROOT_MOUNT

    # busybox switch_root supports -c option
    exec switch_root -c /dev/console $ROOT_MOUNT /sbin/init $CMDLINE ||
        fatal "Couldn't switch_root, dropping to shell"
}

fatal() {
    echo $1 >$CONSOLE
    echo >$CONSOLE
    exec sh
}

early_setup

[ -z "$CONSOLE" ] && CONSOLE="/dev/console"

read_args

echo "Waiting for removable media..."
C=0
while true
do
  if [ -h /dev/disk/by-label/flash-root ]; then
      break;
  fi

  sleep 1
done

boot_live_root
