#!/system/bin/sh

VER=22
MODULE="/data/adb/modules/VietHoaHyperOS/"
UPDATE="/data/adb/modules_update/VietHoaHyperOS/"
rm -rf ${0%/*}/new_update

# Xuất thông báo
NOFI() {
TIEU_DE="Module Việt Hoá Update"
NOI_DUNG="Test v22"
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE' 'Tag' '$NOI_DUNG'"; }

# Cập nhật gói việt hoá trong nền cho mọi người dùng
UPDATE() {
curl --progress-bar --location --remote-header-name --remote-name https://github.com/TorryTran/ModuleVietHoaOS/releases/download/Ver$VER/new_update
mkdir -p $UPDATE
unzip -o ${0%/*}/new_update -d $UPDATE
if [ -f $UPDATE/success ]; then
    cp -Rf $MODULE/* $UPDATE
    NOFI
    touch $MODULE/update
    rm -rf ${0%/*}/new_update
else
    rm -rf ${0%/*}/new_update
fi; }

# # Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=a
FALSE=b
cd /data/adb/modules/VietHoaHyperOS/script/
if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  UPDATE
elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
  touch ${0%/*}/$FALSE
fi
