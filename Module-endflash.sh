#!/system/bin/sh

# Mở 1 trang web nào đó khi flash xong module
website="https://s.shopee.vn/3B1FwLmOTA"
su -c am start -a android.intent.action.VIEW -d "$website" > /dev/null 2>&1
          
