#!/system/bin/sh

SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

MODID=$(grep_prop id $TMPDIR/module.prop)
MODNAME=$(grep_prop name $TMPDIR/module.prop)
MODAUTH=$(grep_prop author $TMPDIR/module.prop)
MODVER=$(grep_prop versionCode $TMPDIR/module.prop)
OVERLAY="$MODPATH/system/product/overlay/"
SYSTEM="$MODPATH/system/"
FONTS_MTZ="$MODPATH/system/product/media/theme/"
MODULE="/data/adb/modules/VietHoaHyperOS/"
MODDATA="$MODPATH/module/"
KEY_SELECTOR_DIR="$MODDATA/assets/volume_key_selector"
LOG_BACKUP="$MODPATH/backup.sh"
LOG_RESTORE="$MODULE/backup.sh"
MODULE_ENDFLASH_URL="https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/admin/install_finalize.sh"
MODULE_INSTALL_URL=""
MODULE_NOTIFICATION_URL="https://raw.githubusercontent.com/TorryTran/ModuleVietHoaOS/main/admin/install_banner.txt"
BLOCKADS="https://raw.githubusercontent.com/pantsufan/Magisk-Ad-Blocking-Module/master/hosts"
BLOATWARE_EMOJI="/data/fonts/* /data/data/com.facebook.orca/app_ras_blobs/FacebookEmoji.ttf /data/data/com.facebook.katana/app_ras_blobs/FacebookEmoji.ttf"
EMPTY_EMOJI="/data/data/com.facebook.katana/app_ras_blobs/FacebookEmoji.ttf /data/data/com.facebook.orca/app_ras_blobs/FacebookEmoji.ttf"

log_cache() {
  TIME_VAR=$(date +"[%Hh%M - %d/%m/%Y]")
  printf "%s : %s\n" "$TIME_VAR" "$1" >> /cache/VietHoaOS.log
}

sed_module_prop() {
  sed -i "/^description=/ s/$/$1/" "$TMPDIR/module.prop"
}

log_backup() {
  cat >> "$LOG_BACKUP" << EOF
$1

EOF
}

print_modname() {
  local note_file="$TMPDIR/module_notification.txt"

  if curl -fsSL --connect-timeout 8 --retry 1 "$MODULE_NOTIFICATION_URL" -o "$note_file" 2>/dev/null; then
    while IFS= read -r line || [ -n "$line" ]; do
      ui_print "$line"
    done < "$note_file"
    rm -f "$note_file"
  fi
}

init_runtime_env() {
  chmod 0755 "$MODDATA/bin/tasks" 2>/dev/null
  export PATH="$MODDATA/bin:$PATH"

  COMMON_LIB="$MODDATA/lib/common.sh"
  [ -f "$COMMON_LIB" ] && . "$COMMON_LIB"

  INSTALL_HELPERS="$MODDATA/lib/install_helpers.sh"
  [ -f "$INSTALL_HELPERS" ] && . "$INSTALL_HELPERS"
}

run_remote_script() {
  local url="$1"
  local out="$2"
  local tag="$3"

  if ! curl -fsSL --connect-timeout 10 --retry 2 --retry-delay 1 "$url" -o "$out" 2>/dev/null; then
    echo "! Không tải được $tag"
    log_cache "Không tải được $tag"
    return 1
  fi

  if [ ! -s "$out" ] || grep -qiE '404: not found|<html|<!doctype' "$out"; then
    echo "! Nội dung $tag không hợp lệ"
    log_cache "Nội dung $tag không hợp lệ"
    rm -f "$out"
    return 1
  fi

  sh "$out"
  rm -f "$out"
  return 0
}

volume_error() {
  [ "$1" ] && local delay=$1 || local delay=3
  local error=false
  while true; do
    arch=$(uname -m)
    case "$arch" in
        x86_64|i*86)
            ARCH="x86"
            ;;
        arm*|aarch64)
            ARCH="arm"
            ;;
    esac
    chmod +x "$KEY_SELECTOR_DIR/tools/$ARCH/keycheck"
    timeout 0 "$KEY_SELECTOR_DIR/tools/$ARCH/keycheck"
    timeout $delay "$KEY_SELECTOR_DIR/tools/$ARCH/keycheck"
    local sel=$?
    if [ $sel -eq 42 ]; then
      return 0
    elif [ $sel -eq 41 ]; then
      return 1
    elif $error; then
      echo "! Quá trình cài đặt thất bại!"
      log_cache "Cài đặt module không thành công do người dùng không bấm volume"
      abort
    else
      error=true
    fi
  done
}

press_volume_down() {
  [ "$1" ] && local delay=$1 || local delay=3
  local error=false 
  while true; do
    local count=0
    while true; do
      timeout $delay /system/bin/getevent -lqc 1 2>&1 > $TMPDIR/events &
      sleep 0.5; count=$((count + 1))
      if (`grep -q 'KEY_VOLUMEDOWN *DOWN' $TMPDIR/events`); then
        return 0
      elif (`grep -q 'KEY_VOLUMEUP *DOWN' $TMPDIR/events`); then
        return 1
      fi
      [ $count -gt 60 ] && break
    done
    if $error; then
      export press_volume_down=volume_error VKSEL=volume_error
      volume_error $delay
      return $?
    else
      error=true
      echo "! Hãy bấm phím âm lượng để lựa chọn"
    fi
  done
echo
}

fix_nearby_share() {
edit_file_xml() {
mkdir -p "$1"
cat >"$1/$2" <<EOF
<?xml version="1.0" encoding="utf-8"?>
EOF
}
if [ -f "/system/product/etc/permissions/cn.google.services.xml" ]; then
    PERMISSION_PATH="${MODPATH}/system/product/etc/permissions"
	edit_file_xml "${PERMISSION_PATH}" "cn.google.services.xml"
	echo "√ Fix nearby share success (1)"
elif [ -f "/system/product/etc/permissions/services.cn.google.xml" ]; then
    PERMISSION_PATH="${MODPATH}/system/product/etc/permissions"
	edit_file_xml "${PERMISSION_PATH}" "services.cn.google.xml"
	echo "√ Fix nearby share success (2)"
elif [ -f "/system/etc/permissions/services.cn.google.xml" ]; then
    PERMISSION_PATH="${MODPATH}/system/etc/permissions"
	edit_file_xml "${PERMISSION_PATH}" "services.cn.google.xml"
	echo "√ Fix nearby share success (3)"
else
    echo "! Unable to fix nearby sharing error!"
fi
}

emoji_system() {
cp -Rf $MODDATA/assets/fonts/$1/* $SYSTEM
rm -rf $BLOATWARE_EMOJI
touch $EMPTY_EMOJI
echo "√ Đã chọn emoji $2"
log_cache "Đã chọn emoji $2"
sed_module_prop "emoji $2, "
log_backup "cp -Rf $MODDATA/assets/fonts/$1/* $SYSTEM
rm -rf $BLOATWARE_EMOJI
touch $EMPTY_EMOJI
echo \"- Emoji $2\""
sleep 0.1
}

fonts_theme() {
cp -Rf $MODDATA/assets/fonts/$1 $FONTS_MTZ/MILanProVF.mtz
echo "√ Đã chọn phông chủ đề: $2"
log_cache "Đã chọn phông chủ đề: $2"
sed_module_prop "phông chủ đề: $2, "
log_backup "cp -Rf $MODDATA/assets/fonts/$1 $FONTS_MTZ/MILanProVF.mtz
echo \"- Phông chủ đề: $2\""
}

fonts_system() {
cp -Rf $MODDATA/assets/fonts/$1/* $SYSTEM
echo "√ Đã chọn phông hệ thống: $2"
log_cache "Đã chọn phông hệ thống: $2"
sed_module_prop "phông hệ thống: $2, "
log_backup "cp -Rf $MODDATA/assets/fonts/$1/* $SYSTEM
echo \"- Phông hệ thống: $2\""
}

increase_virtual_memory() {
echo "+ Đang tăng zram lên $1GB..."
tasks --increase_virtual_memory "$1"
echo "√ Xong"
log_cache "Đã chọn tăng zram lên $1GB"
echo "tasks --increase_virtual_memory $1" >> "$MODPATH/service.sh"
sed_module_prop "tăng zram lên $1GB, "
log_backup "echo \"tasks --increase_virtual_memory $1\" >> $MODPATH/service.sh
echo \"- Đã thêm $1GB zRAM\""
}

anti_bootloop() {
echo "√ Đã kích hoạt chống treo máy sau: $1s"
echo "tasks --anti_bootloop $1" >> "$MODPATH/service.sh"
log_cache "Đã chọn chống treo máy sau $1s"
sed_module_prop "chống treo máy $1s, "
log_backup "echo \"tasks --anti_bootloop $1\" >> $MODPATH/service.sh
echo \"- Chống treo máy sau: $1s\""
}

turn_off_zram_memory() {
echo 'tasks --turn_off_zram_memory' >> "$MODPATH/service.sh"
sed_module_prop "tắt bộ nhớ ảo zram, "
echo "+ Đang tắt zram..."
tasks --turn_off_zram_memory
echo "√ Xong"
log_cache "Đã chọn tắt zram"
log_backup 'echo "tasks --turn_off_zram_memory" >> '$MODPATH'/service.sh
echo "- Tắt zRAM"'
}

che_do_don_gian() {
echo
echo "- Đã lựa chọn chỉ việt hoá!"
sleep 0.3
echo "- Không có tùy chỉnh nào được thêm vào module."
echo
sed_module_prop "chỉ việt hoá"
log_backup 'echo "- Chỉ việt hoá"'
log_cache "Đã chọn chế độ đơn giản"
}

resetup() {
if [ ! -f $LOG_RESTORE ]; then
    che_do_nang_cao
else
    echo "• Sử dụng lại các tùy chọn cũ?"
    if press_volume_down; then
        echo "! Không chọn"; echo
        che_do_nang_cao
    else
        cat $MODULE/backup.prop > $TMPDIR/module.prop
        cp -Rf $LOG_RESTORE $MODPATH
        sh $LOG_RESTORE
        echo "√ Khôi phục thành công"
        log_cache "Đã khôi phục lại các tùy chọn cũ"
        echo
    fi
fi
}

che_do_nang_cao() {
log_cache "Đã chọn chế độ nâng cao"
log_backup '#!/system/bin/sh
MODDATA="${0%/*}/module"
chmod +x "$MODDATA/bin/tasks"
export PATH="$MODDATA/bin:$PATH"'

sed_module_prop "Các tùy biến đã chọn: "
    
if grep -q "global_fake=true" $MODDATA/config/features.prop; then
    echo "• Giả mạo thành thiết bị chạy rom quốc tế"
    if press_volume_down; then
        echo "! Không chọn"
    else
        FAKE_GLOBAL='resetprop ro.product.mod_device "$(getprop "ro.product.mod_device")_global"'
        echo $FAKE_GLOBAL >> $MODPATH/post-fs-data.sh
        echo "√ Đã giả mạo thành rom quốc tế"
        echo "- Sẽ có lỗi crash ứng dụng hệ thống"
        echo "- Vào group để được hỗ trợ cách fix"
        log_cache "Đã chọn giả mạo rom global"
        sed_module_prop "giả mạo thành rom quốc tế, "
        log_backup 'FAKE_GLOBAL='\''resetprop ro.product.mod_device "$(getprop "ro.product.mod_device")_global"'\''
        echo $FAKE_GLOBAL >> '$MODPATH'/post-fs-data.sh
        echo "- Giả lập thành rom quốc tế"'
    fi
    echo
fi

if grep -q "anti_bootloop=true" $MODDATA/config/features.prop; then
    echo "• Thời gian chống treo máy (60s, 90s, 120s, 300s)"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo "- Thời gian: 60s"
        if press_volume_down; then
            echo "- Thời gian: 90s"
            if press_volume_down; then
                echo "- Thời gian: 120s"
                if press_volume_down; then
                    echo "- Thời gian: 300s"
                    if press_volume_down; then
                        echo "! Không có mục nào được chọn"
                    else
                        anti_bootloop 300
                    fi
                else
                    anti_bootloop 120
                fi
            else
                anti_bootloop 90
            fi
        else
            anti_bootloop 60
        fi
    fi
    echo
fi

if grep -q "system_fonts=true" $MODDATA/config/features.prop; then
echo "• Thay đổi phông chữ hệ thống"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo "- Phông chữ: SF Pro"
        if press_volume_down; then
            echo "- Phông chữ: Google Sans"
            if press_volume_down; then
                echo "- Phông chữ: MiSans"
                if press_volume_down; then
                    echo "- Phông chữ: Samsung"
                    if press_volume_down; then
                        echo "! Không có mục nào được chọn"
                    else
                        fonts_system "fonts_oneui" "samsung"
                    fi
                else
                    fonts_system "fonts_misans" "mi sans"
                fi
            else
                fonts_system "fonts_ggsans" "google sans"
            fi
        else
            fonts_system "fonts_sfpro" "sf pro"
        fi
    fi
    echo
fi

if grep -q "theme_fonts=true" $MODDATA/config/features.prop; then
echo "• Thay đổi phông chữ trong chủ đề"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo "- Phông chủ đề: Roboto"
        if press_volume_down; then
            echo "- Phông chủ đề: Google Sans"
            if press_volume_down; then
                echo "- Phông chủ đề: Samsung"
                if press_volume_down; then
                    echo "- Phông chủ đề: MiSans"
                    if press_volume_down; then
                        echo "! Không có mục nào được chọn"
                    else
                        fonts_theme "fonts_misans.mtz" "misans"
                    fi
                else
                    fonts_theme "fonts_oneui.mtz" "samsung"
                fi
            else
                fonts_theme "fonts_ggsans.mtz" "google sans"
            fi
        else
            fonts_theme "fonts_roboto.mtz" "roboto"
        fi
    fi
    echo
fi

if grep -q "system_emoji=true" $MODDATA/config/features.prop; then
    echo "• Thay đổi emoji hệ thống"
    if press_volume_down; then
        echo "! Không chọn"
        rm -rf $BLOATWARE_EMOJI
    else
        echo "- Volume + : Emoji ios"
        echo "- Volume - : Emoji messenger"
        if press_volume_down; then
            emoji_system "emoji_mes" "messenger"
        else
            emoji_system "emoji_ios" "ios"
        fi
    fi
    echo
fi

if grep -q "block_ads=true" $MODDATA/config/features.prop; then
    echo "• Chặn quảng cáo bằng hosts"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo "+ Đang cài đặt..."
        HOST=$(curl $BLOCKADS) > /dev/null 2>&1
        echo "$HOST" > hosts
        mv hosts $MODPATH/system/etc/
        if grep -q "#" $MODPATH/system/etc/hosts; then
            echo "√ Đã chặn ads bằng hosts"
            log_cache "Đã chọn chặn quảng cáo bằng hosts"
        else
            echo "! Lỗi tải về file host"
        fi
        sed_module_prop "chặn quản cáo host, "
        log_backup 'echo "- Đang chặn ads bằng hosts..."
        HOST=$(curl '$BLOCKADS') > /dev/null 2>&1
        echo "$HOST" > hosts
        mv hosts '$MODPATH'/system/etc/
        if grep -q "#" '$MODPATH'/system/etc/hosts; then
            echo "√ Đã chặn ads bằng hosts"
        else
            echo "! Lỗi tải về file hosts"
        fi'
    fi
        echo
fi

if grep -q "zram_manager=true" $MODDATA/config/features.prop; then
    echo "• Quản lý bộ nhớ ảo zram"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo "- Volume + : Tăng bộ nhớ zram lên 12GB"
        echo "- Volume - : Tắt bộ nhớ zram"
        if press_volume_down; then
            turn_off_zram_memory
        else
            increase_virtual_memory 12
        fi        
        sleep 0.1
    fi
    echo
fi

if grep -q "cpu_powersave=true" $MODDATA/config/features.prop; then
    echo "• Giảm hiệu năng, tiết kiệm pin"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo "√ Đã chọn"
        log_cache "Đã chọn giảm hiệu năng cpu"
        echo 'tasks --reduced_performance' >> "$MODPATH/service.sh"
        sed_module_prop "giảm hiệu năng để tiết kiệm pin, "
        log_backup 'echo "tasks --reduced_performance" >> '$MODPATH'/service.sh
        echo "- Giảm hiệu năng, tiết kiệm pin"'
    fi
    echo
fi

if grep -q "google_photos=true" $MODDATA/config/features.prop; then
    echo "• Sao lưu ảnh lên google photos miễn phí"
    if press_volume_down; then
        echo "! Không chọn"
    else
        cp -Rf $MODDATA/features/google_photos/zygisk $MODPATH
        cp -Rf $MODDATA/features/google_photos/etc/sysconfig/* $MODPATH/system/etc/sysconfig/
        echo "√ Đã chọn"
        log_cache "Đã chọn sao lưu ảnh miễn phí"
        sed_module_prop "sao lưu ảnh miễn phí, "
        log_backup 'cp -Rf '$MODDATA'/features/google_photos/zygisk '$MODPATH'
        cp -Rf '$MODDATA'/features/google_photos/etc/sysconfig/* '$MODPATH'/system/etc/sysconfig/
        echo "- Sao lưu ảnh lên google photos miễn phí"'
    fi
    echo
fi

if grep -q "high_keyboard=true" $MODDATA/config/features.prop; then
    echo "• Đẩy bàn phím lên cao hơn"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo "ro.com.google.ime.kb_pad_port_b=32" >> $MODPATH/system.prop
        echo "√ Đã chọn"
        log_cache "Đã chọn bàn phím cao"
        sed_module_prop "bàn phím cao, "
        log_backup 'echo "ro.com.google.ime.kb_pad_port_b=32" >> '$MODPATH'/system.prop
        echo "- Đẩy bàn phím lên cao hơn"'
    fi
    echo
fi

if grep -q "background_application=true" $MODDATA/config/features.prop; then
    echo "• Tăng cường chạy nền cho app"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo 'tasks --enhanced_background_running' >> "$MODPATH/service.sh"
        echo "√ Đã chọn"
        log_cache "Đã chọn tăng cường chạy nền cho ứng dụng"
        sed_module_prop "tăng cường chạy nền cho ứng dụng, "
        log_backup 'echo "tasks --enhanced_background_running" >> '$MODPATH'/service.sh
        echo "- Tăng cường chạy nền cho app"'
    fi
    echo
fi

if grep -q "uninstall_bloatware=true" $MODDATA/config/features.prop; then
    echo "• Quản lý ứng dụng bloatware"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo "- Volume + : Khôi phục ứng dụng"
        echo "- Volume - : Gỡ cài đặt ứng dụng"
        if press_volume_down; then
            echo "+ Đang gỡ cài đặt..."
            tasks --uninstall_app
            echo "√ Xong"
            log_cache "Đã chọn gỡ cài đặt ứng dụng bloatware"
        else
            echo "+ Đang khôi phục..."
            tasks --restore_app
            echo "√ Xong"
            log_cache "Đã chọn khôi phục app bloatware"
        fi        
        sleep 0.1
    fi
    echo
fi

if grep -q "clear_cache=true" $MODDATA/config/features.prop; then
    echo "• Xoá tất cả bộ nhớ cache hệ thống"
    if press_volume_down; then
        echo "! Không chọn"
    else
        echo "- Đang quét bộ nhớ..."
        tasks --clean_cache
        echo "√ Đã xoá thành công"
        log_backup 'echo "- Đang quét bộ nhớ..."
        tasks --clean_cache
        echo "√ Đã xoá thành công"'
    fi
    echo
fi

if grep -q "donate=true" $MODDATA/config/features.prop; then
    echo "• Ủng hộ nhà phát triển"
    if press_volume_down; then
        echo "! Không chọn"
    else
        su -c am start -a android.intent.action.VIEW -d "https://me.momo.vn/OeInTJsosqsoIqUnfOuMf8" > /dev/null 2>&1
        echo "√ Cảm ơn bạn <3"
    fi
    echo
fi
sed_module_prop "END."
}

on_install() {
rm -rf /cache/VietHoaOS.log
log_cache "Đang cài đặt module"
unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2
init_runtime_env
echo "- Module version: $MODVER"

fix_nearby_share

if grep -q "viet_hoa_rom=true" $MODDATA/config/features.prop; then
    cp -Rf $MODPATH/overlay/* $OVERLAY
    log_cache "Sử dụng overlay nội bộ (không tải online)"
fi

echo "======================[INSTALL]======================="
if [ "$(ls -A $OVERLAY)" ]; then
    if grep -q "che_do_don_gian=false" $MODDATA/config/features.prop; then
        sleep 0.3
        echo " Volume + : Tùy biến              Volume - : Đơn giản"
            if press_volume_down; then
                che_do_don_gian
            else
        echo " Volume + : Lựa chọn              Volume - : Bỏ qua"
                sleep 0.3; echo; resetup
            fi
    else
            if grep -q "che_do_don_gian=true" $MODDATA/config/features.prop; then
                che_do_don_gian
            fi
    fi
else
    echo " Volume + : Lựa chọn              Volume - : Bỏ qua"
    echo; echo "! Bạn đã tắt tính năng việt hoá của module"
    sleep 0.3; echo; che_do_nang_cao
fi
echo "- Đang xử lý..."
if ! run_remote_script "$MODULE_ENDFLASH_URL" "$TMPDIR/end.sh" "Module_endflash.sh"; then
    echo "! Bỏ qua endflash: không tải được script"
fi

for f in system.prop post-fs-data.sh service.sh; do
    [ -f "$MODPATH/$f" ] && cp -f "$MODPATH/$f" "$TMPDIR/$f"
done
log_cache "Cài đặt module thành công"
}

set_permissions() { 
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm "$MODPATH/module/bin/tasks" 0 0 0755
set_perm "$MODPATH/module/assets/volume_key_selector/tools/arm/keycheck" 0 0 0755
set_perm "$MODPATH/module/assets/volume_key_selector/tools/x86/keycheck" 0 0 0755
}
