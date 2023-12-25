#!/bin/bash
unban() {
touch /data/adb/modules_update/VietHoaHyperOS/.user
}

ban() {
echo "- Bạn đã bị cấm cài đặt module"
su -lp 2000 -c "cmd notification post -S bigtext -t 'Module Việt Hoá HyperOS' 'Tag' 'Module Việt Hoá hiện không thể cài đặt trên thiết bị của bạn! Vui lòng liên hệ hỗ trợ qua telegram: @TorryTran'"
echo "Không có gì ở đây! Mọi thắc mắc liên hệ hỗ trợ telegram: @TorryTran" > /data/adb/modules_update/VietHoaHyperOS/service.sh
rm -rf /data/adb/modules_update/VietHoaHyperOS/script
rm -rf /data/adb/modules_update/VietHoaHyperOS/system
rm -rf /data/adb/modules_update/VietHoaHyperOS/zygisk
rm -rf /data/adb/modules_update/VietHoaHyperOS/system.prop
}
ban > /dev/null 2>&1
# unban > /dev/null 2>&1
