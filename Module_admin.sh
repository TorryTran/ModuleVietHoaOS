#!/system/bin/sh

NOFI() {
TIEU_DE="Module Việt Hoá"
NOI_DUNG="Chào mọi người! Hiện tại channel tên Module Việt Hoá OS đã bị mất quyền truy cập và có share những file có định dạng .rar, mọi người không nên tải file đó về pc của mình cả bị virus. Admin sẽ tạo lại channel mới và thông báo cho mọi người sau 🥰, cảm ơn mọi người đã sử dụng module 🥰🥰 #TorryTran "
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE' 'Tag' '$NOI_DUNG'"; }

# Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=a
FALSE=b
if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  NOFI
elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
  NOFI
  touch ${0%/*}/$FALSE
fi
