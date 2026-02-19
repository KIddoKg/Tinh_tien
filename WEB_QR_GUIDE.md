# 📱 Hướng dẫn QR Code trên Web

## ⚠️ Vấn đề Camera trên Web

### Tại sao không thể quét QR trên Vercel (HTTP)?

Trình duyệt web (Chrome, Firefox, Safari...) **BẮT BUỘC HTTPS** để truy cập camera vì lý do bảo mật:
- ✅ `https://` - Camera hoạt động
- ✅ `http://localhost` - Camera hoạt động (ngoại lệ)
- ❌ `http://your-app.vercel.app` - Camera BỊ CHẶN

### Giải pháp đã triển khai

#### 1️⃣ **Trên Mobile (Android/iOS)**
- ✅ Nút **Quét QR** hoạt động bình thường
- ✅ Camera mở trực tiếp
- ✅ Không cần HTTPS

#### 2️⃣ **Trên Web với HTTPS**
- ✅ Nút **Quét QR** hiển thị
- ✅ Camera hoạt động nếu user cho phép
- ✅ Tự động kiểm tra `Uri.base.scheme == 'https'`

#### 3️⃣ **Trên Web với HTTP** (Vercel mặc định)
- ⚙️ Nút **Nhập mã QR** (icon keyboard)
- 📝 User có thể **dán** QR code dưới dạng text
- 💡 Thông báo: "Camera cần HTTPS để hoạt động trên web"

## 🚀 Cách sử dụng

### Người chia sẻ game (có HTTPS hoặc mobile):
1. Nhấn nút **QR Code** trong game
2. Chụp màn hình hoặc copy text từ QR code
3. Gửi cho người khác qua chat/email

### Người nhận (trên web HTTP):
1. Mở app trên Vercel
2. Thấy nút **Nhập mã QR** (thay vì Quét QR)
3. Nhấn vào → Dialog hiện ra
4. **Dán** mã QR vào text field
5. Nhấn **Tải game**
6. ✅ Game được import thành công!

## 🔧 Nâng cấp lên HTTPS trên Vercel

### Cách bật HTTPS trên Vercel:

1. **Truy cập Vercel Dashboard**
   - Vào project settings

2. **Domains**
   - Vercel tự động cấp HTTPS cho domain `.vercel.app`
   - Nếu dùng custom domain, cần cấu hình SSL

3. **Force HTTPS Redirect**
   - Settings → General → Force HTTPS
   - Bật tùy chọn này để tự động redirect HTTP → HTTPS

### Sau khi bật HTTPS:
```
http://your-app.vercel.app → https://your-app.vercel.app
```
→ Nút **Quét QR** sẽ tự động xuất hiện thay vì **Nhập mã QR**!

## 📊 Logic kiểm tra Platform

```dart
// Code tự động điều chỉnh UI dựa trên platform
if (!kIsWeb || (kIsWeb && Uri.base.scheme == 'https'))
  // Hiển thị nút QUÉT QR (camera)
else
  // Hiển thị nút NHẬP MÃ QR (text input)
```

## 💡 Best Practices

### Cho người dùng mobile:
- ✅ Dùng chức năng **Quét QR** trực tiếp
- ⚡ Nhanh và tiện lợi

### Cho người dùng web HTTP:
- 📝 Dùng **Nhập mã QR** bằng text
- 🔗 Copy/paste QR code từ người chia sẻ

### Cho production:
- 🔒 **Luôn deploy với HTTPS**
- 🚀 Vercel tự động cấp HTTPS miễn phí
- ✅ Camera hoạt động tốt nhất

## 🐛 Troubleshooting

### Camera không hoạt động trên web?
1. Kiểm tra URL: `http://` hay `https://`?
2. Kiểm tra permissions trình duyệt
3. Thử nhấn nút **Nhập mã QR** thay thế

### QR code không import được?
1. Đảm bảo dán đúng **toàn bộ** mã QR
2. Mã QR phải từ game **chưa kết thúc**
3. Kiểm tra format JSON hợp lệ

## 📌 Tóm tắt

| Platform | HTTP | HTTPS |
|----------|------|-------|
| Android/iOS | ✅ Quét QR | ✅ Quét QR |
| Web (localhost) | ✅ Quét QR | ✅ Quét QR |
| Web (Vercel) | 📝 Nhập mã | ✅ Quét QR |

**Khuyến nghị:** Deploy với HTTPS trên Vercel để có trải nghiệm tốt nhất! 🎯
