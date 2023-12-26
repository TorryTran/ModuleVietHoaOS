#!/system/bin/sh

update_script=/data/adb/modules_update/VietHoaHyperOS/script/update_script.sh
####################################
# Đây là script được ghi vào file update_script.sh
script_code="#!/system/bin/sh

# Chưa có bản vá lỗi nào ở đây
# Module Việt Hoá OS by TorryTran

"
####################################
echo "$script_code" > "$update_script"

####################################
# Dưới đây là script được chạy khi flash module:
echo "- Đã nhận dữ liệu cập nhật từ máy chủ"
su -lp 2000 -c "cmd notification post -S bigtext -t 'Module Việt Hoá HyperOS by TorryTran' 'Tag' 'Hello! Cảm ơn bạn đã sử dụng module, nếu có lỗi gì thì báo với mình tại group telegram: @VietHoaHyper hoặc @mi13vn nha 🥰🥰'" > /dev/null 2>&1
