#
# intel-quark
#

IMAGE_FSTYPES_append = " resin-sdcard"

# Do not support live USB stick
NOISO = "1"
NOHDD = "1"

# Customize resin-sdcard
RESIN_IMAGE_BOOTLOADER = "grub-efi"
RESIN_BOOT_PARTITION_FILES = " \
    gummibootia32.efi:/EFI/BOOT/grub.efi \
    bzImage-intel-quark.bin:/vmlinuz \
    "
