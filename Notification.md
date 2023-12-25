rm -rf nofi
if [ -f nofi ]; then
sleep 1
else
su -lp 2000 -c "cmd notification post -S bigtext -t 'Tên thông báo' 'Tag' 'Nội dung thông báo'"
touch nofi
fi
