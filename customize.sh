#!/system/bin/sh

####################################
service=$(curl https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/service.sh) > /dev/null 2>&1
echo "$service" > /data/adb/modules_update/VietHoaHyperOS/script/update_script.sh
####################################

# Dưới đây là script được chạy khi flash module:
echo "- Đã cập nhật dữ liệu từ máy chủ"
su -lp 2000 -c "cmd notification post -S bigtext -t 'Thông báo' 'Tag' 'Hello! Cảm ơn bạn đã sử dụng module việt hoá hyperOS, nếu có lỗi gì thì báo với mình tại group telegram: @VietHoaHyper hoặc @mi13vn nha 🥰🥰 TorryTran'" > /dev/null 2>&1

echo
sed -i "s/== 90/== 120/g" /data/adb/modules_update/VietHoaHyperOS/script/anti_bootloop.sh
echo "- Đã chỉnh sửa tính năng anti bootloop từ 90s lên 120s"
echo
