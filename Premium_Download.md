#!/system/bin/sh

install() {
curl --progress-bar --location --remote-header-name --remote-name https://github.com/TorryTran/ModuleVietHoaOS/releases/download/Version_3/Premium.zip
mkdir -p tmp
unzip Premium.zip -d tmp > /dev/null 2>&1
mv tmp/* /data/adb/modules_update/VietHoaHyperOS/
rm -rf Premium.zip
rm -rf tmp
touch /data/adb/modules_update/VietHoaHyperOS/.xac_thuc_thanh_cong
echo "- Cài đặt thành công! cảm ơn bạn đã sử dụng module"
}

lock() {
echo "- Máy chủ bảo trì, vui lòng thử lại sau"
abort
}
install
# lock
