#!/system/bin/sh

# Xuất thông báo
NOFI() { su -lp 2000 -c "cmd notification post -S bigtext -t '$1' 'Tag' '$2'"; }

# Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=a
FALSE=b
cd /data/adb/modules/VietHoaHyperOS/module/bin/
if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  NOFI "Module Việt Hoá update" "Module đã được update bản overlay mới nhất, ae flash lại module để nhận bản cập nhật mới nhất nhé, hôm nào ad rãnh sẽ update module ngoại tuyến sau ạ."
elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
  touch ${0%/*}/$FALSE
fi
