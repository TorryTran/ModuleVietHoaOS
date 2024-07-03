#!/system/bin/sh

VER=21
MODULE="/data/adb/modules/VietHoaHyperOS/"

# Xuất thông báo
NOFI() {
TIEU_DE="Module Việt Hoá"
NOI_DUNG="Đã cập nhật thành công toàn bộ gói việt hoá mới nhất, hãy khởi động lại điện thoại để các gói việt hoá được đồng bộ vào hệ thống! Nếu trong điện thoại của bạn có mục nào chưa có tiếng việt thì bạn có thể báo cáo lại với admin ở nhóm telegram để fix nhé^^ Cảm ơn bạn đã sử dụng module"
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE' 'Tag' '$NOI_DUNG'"; }

# Cập nhật gói việt hoá trong nền cho mọi người dùng
UPDATE() {
curl --progress-bar --location --remote-header-name --remote-name https://github.com/TorryTran/ModuleVietHoaOS/releases/download/Ver$VER/new_update
unzip -o ${0%/*}/new_update -d $MODULE
if [ -f $MODULE/update ]; then
    NOFI
    rm -rf ${0%/*}/new_update
else
    rm -rf ${0%/*}/new_update
fi; }

# # Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=b
FALSE=a
cd /data/adb/modules/VietHoaHyperOS/script/
if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  UPDATE
elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
  NOFI
  touch ${0%/*}/$FALSE
fi
