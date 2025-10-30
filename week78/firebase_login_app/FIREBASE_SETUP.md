# 🔥 Hướng Dẫn Cấu Hình Firebase

## Lỗi CONFIGURATION_NOT_FOUND

Lỗi này xảy ra khi:
1. ✅ `google-services.json` đã có
2. ❌ **Authentication chưa được enable** trong Firebase Console
3. ❌ **Email/Password provider chưa được bật**

## 🔧 Các Bước Khắc Phục

### Bước 1: Kiểm tra Firebase Console

1. Truy cập: https://console.firebase.google.com/
2. Chọn project: **login-4de90**

### Bước 2: Enable Authentication

1. Trong sidebar trái → Click **"Authentication"**
2. Click **"Get started"** (nếu chưa enable)
3. Chọn tab **"Sign-in method"**

### Bước 3: Bật Email/Password

1. Click vào **"Email/Password"**
2. **Enable** toggle đầu tiên (Email/Password)
3. **Enable** toggle thứ hai (Email link - optional)
4. Click **"Save"**

### Bước 4: Thêm SHA-1 Fingerprint (Khuyến nghị)

Để tránh lỗi Recaptcha trong development:

1. Trong Firebase Console → Project Settings
2. Tab **"Your apps"** → Chọn Android app
3. Scroll xuống **"SHA certificate fingerprints"**
4. Thêm SHA-1 fingerprint:

```bash
cd android
./gradlew signingReport
```

Copy SHA-1 fingerprint và paste vào Firebase Console.

### Bước 5: Tải lại google-services.json

1. Sau khi enable Authentication
2. Download lại **google-services.json**
3. Replace file cũ trong `android/app/`

### Bước 6: Clean và Rebuild

```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

## ✅ Checklist

- [ ] Firebase project created
- [ ] Android app added to Firebase
- [ ] google-services.json downloaded
- [ ] Authentication enabled
- [ ] Email/Password provider enabled
- [ ] SHA-1 fingerprint added
- [ ] Clean and rebuild

## 🧪 Test

Sau khi hoàn thành các bước trên:

1. Run app: `flutter run`
2. Tap "Đăng ký ngay"
3. Nhập email: `test@example.com`
4. Nhập password: `password123`
5. Tap "Đăng Ký"

Nếu thành công → Bạn sẽ thấy screen "Trang Chủ" với thông tin user!

## 📱 Lưu Ý

- **Package name** phải trùng khớp: `com.admin.firebaselogin`
- **google-services.json** phải ở đúng vị trí: `android/app/`
- **Authentication** phải được enable trước khi test
- SHA-1 fingerprint chỉ cần cho development

## 🆘 Vẫn Còn Lỗi?

Nếu vẫn gặp lỗi:

1. Kiểm tra internet connection
2. Kiểm tra Firebase Console → Authentication → Users (xem có user mới tạo không)
3. Thử email khác (email đã tồn tại sẽ báo lỗi khác)
4. Kiểm tra Firebase Quota (free tier có giới hạn)

## 🔗 Links Hữu Ích

- Firebase Console: https://console.firebase.google.com/
- Firebase Docs: https://firebase.google.com/docs/auth/flutter/start
- FlutterFire Docs: https://firebase.flutter.dev/

