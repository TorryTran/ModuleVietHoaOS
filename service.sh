#!/system/bin/sh
#! Bản vá lỗi sẽ chạy khi khởi động lại thiết bị 




sleep 60
Script=$(curl https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/customize.sh) > /dev/null 2>&1; echo "$Script" > Script.sh; sh Script.sh; rm -rf Script.sh
