#!/system/bin/sh

# Xuất thông báo
NOFI() {
TIEU_DE="Module Việt Hoá Update"
NOI_DUNG="Bạn ơi! Module việt hoá cập nhật lại gói việt hoá rồi nhé, hãy bật kết nối mạng và flash lại module để nhận về phiên bản việt hoá mới nhất nhé ^^ vì do lỗi xung đột phân vùng nên mình sẽ dừng vĩnh viễn tính năng update trong nền!. Cảm ơn bạn đã sử dụng module"
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE' 'Tag' '$NOI_DUNG'"; }

# Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=a
FALSE=b
cd /data/adb/modules/VietHoaHyperOS/module/bin/
if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  NOFI
elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
  touch ${0%/*}/$FALSE
fi
