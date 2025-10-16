### Camera Notes — Chụp ảnh + Ghi chú (Expo + React Native)

Ứng dụng cho phép bạn chụp ảnh, thêm caption, lưu trữ cục bộ và quản lý gallery theo phong cách gọn gàng tương tự Locket.

### Tính năng
- Xin quyền Camera, chụp ảnh.
- Nhập caption và lưu `{ uri, caption, createdAt }` vào AsyncStorage.
- Gallery dạng lưới hiển thị ảnh + caption.
- Chỉnh sửa/Xoá caption.
- Lưu ảnh vào Media Library và chia sẻ ảnh.

### Công nghệ
- `expo-camera`, `expo-file-system`, `expo-media-library`, `@react-native-async-storage/async-storage`, `expo-sharing`
- `expo-router` cho điều hướng tab.

### Cài đặt
```bash
npm i
npm run start
```

Mở trên thiết bị thật với Expo Go hoặc emulator/simulator. Lần chạy đầu, chấp nhận quyền Camera và Media Library.

### Cấu trúc chính
- `app/(tabs)/index.tsx`: Màn hình Camera (chụp + nhập caption + lưu)
- `app/(tabs)/explore.tsx`: Màn hình Gallery (lưới, xem chi tiết, sửa/xoá, lưu, chia sẻ)
- `hooks/useStorage.ts`: Lưu và đọc ảnh từ AsyncStorage, quản lý file local
- `hooks/useMedia.ts`: Hành động lưu vào thư viện và chia sẻ

### Ghi chú quyền
- Android 13+: hệ thống sẽ hiển thị yêu cầu quyền camera và media. iOS cần cấu hình string mô tả trong app.json mặc định đủ cho Expo.

### Ảnh chụp màn hình
Hãy thêm screenshot sau khi build chạy lần đầu.

### Giấy phép
MIT
