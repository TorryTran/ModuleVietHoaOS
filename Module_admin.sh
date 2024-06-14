#!/system/bin/sh

# Xuất hiện thông báo cho mọi người dùng 
TIEU_DE="Module Việt Hoá"
NOI_DUNG="Chào mọi người! Hiện tại channel tên Module Việt Hoá OS đã bị mất quyền truy cập và có share những file có định dạng .rar, mọi người không nên tải file đó về pc của mình cả bị virus. Admin sẽ tạo lại channel mới và thông báo cho mọi người sau 🥰, cảm ơn mọi người đã sử dụng module 🥰🥰 #TorryTran "
su -lp 2000 -c "cmd notification post -S bigtext -t '$TIEU_DE' 'Tag' '$NOI_DUNG'"
