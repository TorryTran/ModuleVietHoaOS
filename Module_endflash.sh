#!/system/bin/sh

# Mở 1 trang web nào đó khi flash xong module
website="@VietHoaOS_Support"
su -c am start -a android.intent.action.VIEW -d "$website" > /dev/null 2>&1
          
