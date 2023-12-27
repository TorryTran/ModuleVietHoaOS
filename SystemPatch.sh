#!/system/bin/sh
#! Bản vá lỗi sẽ chạy khi flash module
abort
echo "- Đã nhận 1 bản vá lỗi"
echo
echo "- Chỉnh sửa tính năng anti bootloop từ 90s lên 120s"
sed -i "s/== 90/== 120/g" /data/adb/modules_update/VietHoaHyperOS/script/anti_bootloop.sh
echo
echo "- Vá lỗi thành công!"
