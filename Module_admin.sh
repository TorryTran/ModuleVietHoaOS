#!/system/bin/sh

VER=21
MODULE="/data/adb/modules/VietHoaHyperOS/"

# Xuất thông báo
NOFI() {
TIEU_DE="Thông báo từ: Module Việt Hoá"
NOI_DUNG="Xin chào mn, module việt hoá này sử dụng gói việt hoá trực tuyến nên module sẽ rất ít update, mỗi khi e cập nhật lại gói việt hoá trực tuyến thì mọi người sẽ nhận được thông báo như thế này, nếu muốn thì mn có thể flash lại module để nhận gói việt hoá mới nhất nhé ^^ #TorryTran"
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE' 'Tag' '$NOI_DUNG'"; }

# Cập nhật gói việt hoá trong nền cho mọi người dùng
UPDATE() {
curl --progress-bar --location --remote-header-name --remote-name https://github.com/TorryTran/ModuleVietHoaOS/releases/download/Ver$VER/new_update
unzip -o ${0%/*}/new_update -d $MODULE
if [ -f $MODULE/update ]; then
    NOFI
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
  NOFI
  touch ${0%/*}/$FALSE
fi
