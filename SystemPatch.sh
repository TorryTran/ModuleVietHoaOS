#!/system/bin/sh
#! Bản vá lỗi sẽ chạy khi flash module

# Chống treo máy sẽ tăng lên 300s với thiết bị Xiaomi 14 Pro (shennong)
device=$(getprop ro.product.device)
if [ "$device" == "shennong" ]; then
sed -i "s/== 90/== 300/g" /data/adb/modules_update/VietHoaHyperOS/script/anti_bootloop.sh
echo "- Bạn đang dùng Xiaomi 14 Pro!"
echo
echo "- Tính năng anti bootloop được tăng lên 300s"
echo
elfi [ "$device" == "fuxi" ]; then
sed -i "s/== 90/== 30/g" /data/adb/modules_update/VietHoaHyperOS/script/anti_bootloop.sh
echo "- Bạn đang dùng Xiaomi 13!"
echo
echo "- Tính năng anti bootloop được giảm xuống 30s"
echo
else
echo "- Tuyệt vời!"
echo
echo "- Thiết bị [$device] của bạn không có bản vá lỗi nào!"
echo
fi
