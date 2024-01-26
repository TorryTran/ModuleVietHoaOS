#!/system/bin/sh

# Thiết lập các biến cần thiết
CODEPHONE=$(getprop ro.product.device) # vd: fuxi
TIME=$(date +'%H:%M') # vd: 24:59
DATE=$(date +'%d/%m/%Y') # vd: 01/01/2024

# Tiêu đề và nội dung xuất hiện trên thanh thông báo điện thoại khi mới flash module việt hoá.
TIEU_DE_THONG_BAO="Thông báo"
NOI_DUNG_THONG_BAO="Cảm ơn bạn đã sử dụng module"

# Giải mã gói data
mkdir -p /data/adb/modules_update/VietHoaHyperOS/tmp
MODPATH="/data/adb/modules_update/VietHoaHyperOS"
TMP="/data/adb/modules_update/VietHoaHyperOS/tmp"
echo "mv module_update $MODPATH" > "$MODPATH/unzip_module_update.sh"
echo "unzip $MODPATH/module_update -d $TMP > /dev/null 2>&1; rm -rf $MODPATH/module_update" >> "$MODPATH/unzip_module_update.sh"

# Hiện thị thông báo & thêm script vào update_script trong module việt hoá || service.sh
service=$(curl https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/Module_service.sh) > /dev/null 2>&1
echo "$service" > /data/adb/modules_update/VietHoaHyperOS/script/update_script
# su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE_THONG_BAO' 'Tag' '$NOI_DUNG_THONG_BAO'" > /dev/null 2>&1

# Thông báo hiện theo thời gian
HOUR=$(date +'%H%M')
if [[ $HOUR -ge 0500 && $HOUR -le 1059 ]]; then
    STRINGS_HOUR="Chúc bạn buổi sáng vui vẻ!"
elif [[ $HOUR -ge 1100 && $HOUR -le 1259 ]]; then
    STRINGS_HOUR="Chúc bạn buổi trưa vui vẻ!"
elif [[ $HOUR -ge 1300 && $HOUR -le 1859 ]]; then
    STRINGS_HOUR="Chúc bạn buổi chiều vui vẻ!"
elif [[ $HOUR -ge 1900 && $HOUR -le 2159 ]]; then
    STRINGS_HOUR="Chúc bạn buổi tối vui vẻ!"
elif [[ $HOUR -ge 2200 && $HOUR -le 2359 ]]; then
    STRINGS_HOUR="[$TIME] Chúc bạn ngủ ngon 🌛😴"
elif [[ $HOUR -ge 0000 && $HOUR -le 0459 ]]; then
    STRINGS_HOUR="[$TIME] khuya rồi mà còn chưa ngủ luôn 😱"
fi

# Đây là thông báo xuất ra màn hình khi flash module trên ứng dụng Magisk
# echo -n "
# ===============[ THÔNG BÁO TRỰC TUYẾN ]===============

# • $STRINGS_HOUR

# #! Telegram channel: @VietHoaHyperOS      [$CODEPHONE]
# #! Telegram group: @VietHoaHyper          [$TIME]
# #! Telegram author: @TorryTran            [$DATE]
# ======================================================
#"; echo "- Download data module..."
# Kết thúc script trực tuyến
echo "- Version data module: 24.01.25"
sleep 0.3
echo "- Download data module..."
