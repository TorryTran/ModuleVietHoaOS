#!/system/bin/sh

# Quản lý module
sleep 60
while true
do
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
        curl -L -G -N -k https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/Module_admin.sh > ${0%/*}/admin.sh
        sh ${0%/*}/admin.sh
        rm -rf ${0%/*}/admin.sh
    fi
sleep 6h
done
