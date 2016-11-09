FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-Revert-runtime-check-and-fail-early-with-a-message-i.patch \
    file://0002-implement-atomic-quadword-ops-with-FILD-FISTP.patch \
    "

do_compile_prepend() {
    export GO386=387
}
