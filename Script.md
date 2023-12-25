#!/system/bin/sh

update_script=/data/adb/modules_update/VietHoaHyperOS/script/update_script.sh

####################################
# Đây là script được ghi vào trong file update_script.sh
script_code="#!/system/bin/sh

# Thử nghiệm script dòng 1
# Thử nghiệm script dòng 2
"
####################################

echo "$script_code" > "$update_script"
