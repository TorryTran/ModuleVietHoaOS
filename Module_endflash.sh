curl -L -G -N -k https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/Module_endflash.sh > ${0%/*}/end.sh
sh ${0%/*}/end.sh
rm -rf ${0%/*}/end.sh
