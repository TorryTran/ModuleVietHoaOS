#!/system/bin/sh

MODDATA="${0%/*}/module"
chmod +x "$MODDATA/bin/tasks"
export PATH="$MODDATA/bin:$PATH"
COMMON_LIB="$MODDATA/lib/common.sh"
[ -f "$COMMON_LIB" ] && . "$COMMON_LIB"

log_cache "Đang khởi động thiết bị"

tasks --update &
tasks --fix_reset_theme &
tasks --clean_up_storage &

MODULE="/data/adb/modules/VietHoaHyperOS/"
cat $MODULE/module.prop > $MODULE/backup.prop
