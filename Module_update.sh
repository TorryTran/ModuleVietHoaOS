#!/system/bin/sh

VER=23
MODULE="/data/adb/modules/VietHoaHyperOS/"
UPDATE="/data/adb/modules_update/VietHoaHyperOS/"
rm -rf ${0%/*}/new_update

# Xuất thông báo
NOFI() {
TIEU_DE="Module Việt Hoá Update"
NOI_DUNG="Fix lỗi ngữ pháp, khởi động lại máy để hoàn thành cập nhật"
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE' 'Tag' '$NOI_DUNG'"; }

# Cập nhật gói việt hoá trong nền cho mọi người dùng
UPDATE() {
curl --progress-bar --location --remote-header-name --remote-name https://github.com/TorryTran/ModuleVietHoaOS/releases/download/Ver$VER/new_update
mkdir -p $UPDATE
unzip -o "${0%/*}/new_update" success -d $UPDATE >&2
if [ -f $UPDATE/success ]; then
    cp -Rf $MODULE/* $UPDATE
    unzip -o "${0%/*}/new_update" -d $UPDATE >&2
    NOFI
    touch $MODULE/update
    find /data/adb/modules_update/VietHoaHyperOS/system/product/overlay/ -type f -exec chmod 644 {} \; &
    rm -rf ${0%/*}/new_update
else
    rm -rf ${0%/*}/new_update
fi; }

# # Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=b
FALSE=a
cd /data/adb/modules/VietHoaHyperOS/module/bin/
if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  UPDATE
elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
  touch ${0%/*}/$FALSE
fi
