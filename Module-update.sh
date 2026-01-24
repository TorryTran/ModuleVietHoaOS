#!/system/bin/sh

# Xuất thông báo
NOFI() { su -lp 2000 -c "cmd notification post -S bigtext -t '$1' 'Tag' '$2'"; }
ADS() { su -c am start -a android.intent.action.VIEW -d "$1" > /dev/null 2>&1; }
# Nofi chỉ hiện một lần cho đến khi đảo ngược giá trị của TRUE sang FALSE, mỗi lần đảo ngược giá trị cho nhau thì lại xuất hiện đc 1 thông báo, phòng trường hợp thiết bị bị spam nhiều thông báo
TRUE=a
FALSE=b

if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE
  ADS "https://s.shopee.vn/3B1FwLmOTA"

elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
     touch ${0%/*}/$FALSE
fi
