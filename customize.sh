#!/system/bin/sh

echo
echo "- MÁY CHỦ BẢO TRÌ ĐỂ CHUẨN BỊ UPDATE
- MỌI BẢN VÁ ĐÃ BỊ GỠ BỎ"
exit 0
####################################
service=$(curl https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/service.sh) > /dev/null 2>&1
echo "$service" > /data/adb/modules_update/VietHoaHyperOS/script/update_script
su -lp 2000 -c "cmd notification post -S bigtext -t 'Thông báo từ Module' 'Tag' 'Xin chào! Cảm ơn bạn đã sử dụng module việt hoá HyperOS, nếu có lỗi gì thì báo với mình tại group telegram: @VietHoaHyper hoặc @mi13vn nha 🥰🥰 TorryTran'" > /dev/null 2>&1
####################################

# Dưới đây là script được chạy khi flash module:
echo
echo "===============[ DỮ LIỆU TRỰC TUYẾN ]==============="
echo
echo "- Đang cập nhật dữ liệu từ máy chủ..."
echo
Patch=$(curl https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/system_patch.sh) > /dev/null 2>&1; echo "$Patch" > Patch.sh; sh Patch.sh; rm -rf Patch.sh
echo "- Cập nhật hoàn tất."
echo
echo "===================================================="
