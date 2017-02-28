include resin-image.inc

IMAGE_DEPENDS_resinos-img_append = " core-image-minimal-initramfs:do_rootfs"

# Put the initramfs inside the boot partition
RESIN_BOOT_PARTITION_FILES_append += " \
    core-image-minimal-initramfs-intel-quark.cpio.gz:/initramfs \
    grub.cfg_external:/boot/grub/grub.conf \
    grub.cfg_internal:/ \
    "
