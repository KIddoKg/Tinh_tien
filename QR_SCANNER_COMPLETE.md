# ✅ QR Code Scanner hoàn chỉnh cho Web & Mobile

## 📦 Package đã cài đặt

```yaml
qr_flutter: ^4.1.0          # Tạo QR code
qr_code_scanner_plus: ^2.1.1  # Scan QR code (✅ Hỗ trợ WEB!)
```

## 🎯 Tính năng

### ✅ Hoạt động trên TẤT CẢ platforms:
- 📱 **Android** - Quét QR bằng camera
- 📱 **iOS** - Quét QR bằng camera  
- 💻 **Web** - Quét QR bằng camera (HTTPS)
- 🌐 **Web HTTP** - Vẫn có thể nhập mã QR text (fallback)

## 🚀 Cách sử dụng

### Người chia sẻ game:
1. Trong game đang chơi
2. Nhấn nút **QR Code** (góc trên bên phải)
3. QR hiển thị ra màn hình
4. Người khác quét hoặc copy text

### Người nhận:
1. Mở app → Màn hình chính
2. Nhấn nút **Scan QR** (icon qr_code_scanner)
3. **Mobile**: Camera mở → Quét QR
4. **Web HTTPS**: Camera mở → Quét QR
5. **Web HTTP**: Sẽ có nút "Nhập mã QR" thay thế
6. Game được import → Chơi tiếp!

## 🔧 Permissions

### Android - `android/app/src/main/AndroidManifest.xml`
```xml
<manifest ...>
    <!-- Camera permission cho QR scanner -->
    <uses-permission android:name="android.permission.CAMERA" />
    
    <!-- Optional: Internet permission (đã có sẵn) -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application>
        ...
    </application>
</manifest>
```

### iOS - `ios/Runner/Info.plist`
```xml
<dict>
    <!-- Camera permission description -->
    <key>NSCameraUsageDescription</key>
    <string>Cần truy cập camera để quét mã QR</string>
    
    ...
</dict>
```

### Web - Tự động xin quyền
- Browser sẽ tự động hỏi khi mở camera
- **Yêu cầu HTTPS** trên production

## 📂 Files đã tạo/cập nhật

### 1. `scan_game_qr_screen.dart` (MỚI)
- Sử dụng `QRView` từ `qr_code_scanner_plus`
- Camera với overlay đẹp
- Flash toggle, flip camera
- Auto-detect và import game

### 2. `zizach_screen.dart` (CẬP NHẬT)
- Nút **Scan QR** luôn hiển thị
- Navigation đến `ScanGameQRScreen`
- Fallback: Nút "Nhập mã QR" cho web HTTP (giữ lại)

### 3. `pubspec.yaml` (CẬP NHẬT)
- Thay `mobile_scanner` → `qr_code_scanner_plus`

## ⚙️ Build & Deploy

### Mobile (Android/iOS)
```bash
# Android
flutter build apk --release

# iOS  
flutter build ios --release
```

### Web
```bash
# Build web
flutter build web --release

# Deploy lên Vercel
vercel --prod

# ✅ HTTPS tự động có trên Vercel!
```

## 🐛 Troubleshooting

### Camera không mở trên web?
1. ✅ Kiểm tra đang dùng HTTPS (https://)
2. ✅ Cho phép camera khi browser hỏi
3. ✅ Thử browser khác (Chrome khuyên dùng)

### QR không quét được?
1. ✅ QR phải sáng, rõ nét
2. ✅ Giữ camera cách QR ~20cm
3. ✅ Đặt QR vào giữa khung quét

### Lỗi import game?
1. ✅ QR phải từ game **chưa kết thúc**
2. ✅ Kiểm tra format JSON hợp lệ
3. ✅ Version phải khớp (1.0)

## 📊 So sánh packages

| Package | Web Support | Mobile | Tính năng |
|---------|-------------|--------|-----------|
| ~~mobile_scanner~~ | ❌ | ✅ | Không web |
| **qr_code_scanner_plus** | ✅ | ✅ | Tốt nhất! |
| qr_code_scanner | ⚠️ | ✅ | Web experimental |

## 🎉 Hoàn tất!

Giờ bạn có thể:
- ✅ Quét QR trên mobile
- ✅ Quét QR trên web (HTTPS)
- ✅ Nhập mã QR text (web HTTP)
- ✅ Chia sẻ game dễ dàng

**Deploy lên Vercel → Tự động có HTTPS → Camera hoạt động hoàn hảo!** 🚀
