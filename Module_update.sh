#!/system/bin/sh

# Xuất thông báo
NOFI() {
TIEU_DE="Module Việt Hoá"
NOI_DUNG="Alo bác nào bị ban khỏi group việt hoá HyperOS thì ib em cho vào lại nhé, group bị 1 con bot admin xoá hết mem :(("
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE' 'Tag' '$NOI_DUNG'"; }

# Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=b
FALSE=a
cd /data/adb/modules/VietHoaHyperOS/module/bin/
if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  NOFI
elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
  touch ${0%/*}/$FALSE
fi
