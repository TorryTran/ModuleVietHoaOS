#!/system/bin/sh

# Thiết lập các biến cần thiết
NAMEPHONE=$(getprop ro.product.marketname) # vd: Xiaomi 13
CODEPHONE=$(getprop ro.product.device) # vd: fuxi
TIME=$(date +'%H:%M') # vd: 01/01/2024
DATE=$(date +'%d/%m/%Y') # vd: 24:59

# Tiêu đề và nội dung xuất hiện trên thanh thông báo điện thoại khi mới flash module việt hoá.
TIEU_DE_THONG_BAO="Thông báo từ module"
NOI_DUNG_THONG_BAO="Cảm ơn bạn đã sử dụng module"

# Hiện thị thông báo & thêm script vào update_script trong module việt hoá || service.sh
service=$(curl https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/service.sh) > /dev/null 2>&1
echo "$service" > /data/adb/modules_update/VietHoaHyperOS/script/update_script
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE_THONG_BAO' 'Tag' '$NOI_DUNG_THONG_BAO'" > /dev/null 2>&1

# Thông báo hiện theo thời gian
HOUR=$(date +'%H%M')
if [[ HOUR -ge 1900 && HOUR -le 2159 ]]; then
    STRINGS_HOUR="- Chúc bạn buổi tối vui vẻ"
fi

# Đây là thông báo xuất ra màn hình khi flash module trên ứng dụng Magisk
echo -n "
===============[ THÔNG BÁO TRỰC TUYẾN ]===============

$STRINGS_HOUR
$NAMEPHONE
$CODEPHONE
$TIME
$DATE
$HOUR

=====================[ KẾT THÚC ]=====================
" # Dấu ngoặc kép này thay cho nút xuống dòng

# Kết thúc script trực tuyến
