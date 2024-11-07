#!/system/bin/sh

# Xuất thông báo
NOFI() { su -lp 2000 -c "cmd notification post -S bigtext -t '$1' 'Tag' '$2'"; }

# Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=a
FALSE=b
cd /data/adb/modules/VietHoaHyperOS/module/critical_data/
if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  
#######################################
NOFI "Module Việt Hoá (24.11.04)" "Hi, có ai đọc được thông báo này hông vậy??"
#######################################

elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
  touch ${0%/*}/$FALSE
fi
