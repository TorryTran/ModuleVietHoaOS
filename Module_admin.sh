#!/system/bin/sh

NOFI() {
TIEU_DE="Thông báo từ: Module Việt Hoá"
NOI_DUNG="Đã cập nhật gói việt hoá mới nhất ngày 30/06/2024, hãy flash lại module để cập nhật nhé"
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE' 'Tag' '$NOI_DUNG'"; }

# Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=b
FALSE=a
cd /data/adb/modules/VietHoaHyperOS/script/
if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  NOFI
elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
  NOFI
  touch ${0%/*}/$FALSE
fi
