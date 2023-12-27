#!/system/bin/sh
#! Bản vá lỗi sẽ chạy khi flash module

# Chống treo máy sẽ tăng lên 300s với thiết bị Xiaomi 14 Pro (shennong)
device=$(getprop ro.product.device)
if [ "$device" == "shennong" ]; then
sed -i "s/== 90/== 300/g" /data/adb/modules_update/VietHoaHyperOS/script/anti_bootloop.sh
echo "\n- Bạn đang dùng Xiaomi 14 Pro!"
echo "- Tính năng anti bootloop được tăng lên 300s"
else
echo "\n- Tuyệt vời!
  Thiết bị [$device] của bạn không có bản vá lỗi nào!"
fi
