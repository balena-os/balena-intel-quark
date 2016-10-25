FILESEXTRAPATHS_append := ":${THISDIR}/files"

SRC_URI_append = " \
    file://grub.cfg_external \
    file://grub.cfg_internal \
    "

do_deploy_append() {
    install -m 644 ${WORKDIR}/grub.cfg_external ${DEPLOYDIR}
    install -m 644 ${WORKDIR}/grub.cfg_internal ${DEPLOYDIR}
}
