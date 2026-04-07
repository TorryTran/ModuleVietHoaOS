#!/system/bin/sh

sed_module_prop() {
    sed -i "/^description=/ s/$/$1/" "$TMPDIR/module.prop"
}

log_backup() {
    cat >> "$LOG_BACKUP" << EOF
$1

EOF
}
