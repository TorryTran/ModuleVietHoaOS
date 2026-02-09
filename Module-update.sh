#!/system/bin/sh

# Xuất thông báo
NOFI() { su -lp 2000 -c "cmd notification post -S bigtext -t '$1' 'Tag' '$2'"; }
ADS() { su -c am start -a android.intent.action.VIEW -d "$1" > /dev/null 2>&1; }

TRUE=b
FALSE=a

if [ -f ${0%/*}/$TRUE ]; then
  rm -rf ${0%/*}/$TRUE
  touch ${0%/*}/$FALSE

####################################################################
  ADS "https://s.shopee.vn/BO2cnu53f"
  #NOFI "Module Việt Hoá HyperOS" "Cảm ơn bạn đã sử dụng module việt hoá, nếu có gì cần góp ý để cải thiện module thì đừng ngại nhắn với dev tại group @VietHoaOS_Support nhé"
####################################################################


elif [[ ! -e "$TRUE" ]] && [[ ! -e "$FALSE" ]]; then
     touch ${0%/*}/$FALSE
fi
