#!/system/bin/sh

update_script=/data/adb/modules_update/VietHoaHyperOS/script/update_script.sh
####################################
# Đây là script được ghi vào file update_script.sh
script_code="#!/system/bin/sh

# Chưa có bản vá lỗi nào ở đây
# Module Việt hoá OS by TorryTran
"
####################################
echo "$script_code" > "$update_script"

####################################
# Dưới đây là script được chạy khi flash module:
echo "- Bản vá lỗi đã được ghi vào module"
