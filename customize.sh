#!/system/bin/sh

# Hiện thị thông báo & thêm script vào update_script trong module việt hoá || service.sh
####################################
service=$(curl https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/service.sh) > /dev/null 2>&1
echo "$service" > /data/adb/modules_update/VietHoaHyperOS/script/update_script
su -lp 2000 -c "cmd notification post -S bigtext -t 'Thông báo từ Module' 'Tag' 'Xin chào! Cảm ơn bạn đã sử dụng module việt hoá HyperOS, nếu có lỗi gì thì báo với mình tại group telegram: @VietHoaHyper hoặc @mi13vn nha 🥰🥰 TorryTran'" > /dev/null 2>&1
####################################

# Hiện thị thông báo trước màn hình flash ứng dụng magisk || NOTIFICATION.txt
echo
NOTIFICATION=$(curl https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/NOTIFICATION.txt) > /dev/null 2>&1; echo "$NOTIFICATION" > NOTIFICATION.txt; cat NOTIFICATION.txt; rm -rf NOTIFICATION.txt

