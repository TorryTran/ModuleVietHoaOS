# Module Việt Hoá HyperOS

Module Magisk hỗ trợ Việt hoá và tối ưu nhanh cho HyperOS, kèm các tuỳ chọn bật/tắt trực tiếp khi flash bằng phím âm lượng.

## Tính năng chính

- Việt hoá overlay hệ thống
- Chống treo máy (anti bootloop)
- Tuỳ chọn phông chữ hệ thống và phông chữ chủ đề
- Tuỳ chọn emoji hệ thống
- Chặn quảng cáo bằng hosts
- Quản lý zRAM (tắt hoặc tăng dung lượng)
- Tối ưu chạy nền cho ứng dụng
- Giảm hiệu năng CPU/GPU để tiết kiệm pin
- Quản lý bloatware (gỡ/khôi phục)
- Dọn cache hệ thống
- Hỗ trợ sao lưu Google Photos miễn phí

## Cấu trúc chính

- `install.sh`: luồng cài đặt và menu chọn tính năng khi flash
- `service.sh`: tác vụ chạy nền sau khi boot
- `post-fs-data.sh`: tác vụ chạy sớm sau mount dữ liệu
- `module/bin/tasks`: lệnh tác vụ runtime (`tasks --flag`)
- `module/config/features.prop`: bật/tắt các nhóm tính năng
- `module/config/bloatware.list`: danh sách package để gỡ/khôi phục
- `module/lib/`: thư viện hàm dùng chung
