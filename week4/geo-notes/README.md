# 📍 Geo-Notes - Ứng dụng ghi chú thông minh theo vị trí

Ứng dụng ghi chú hiện đại được xây dựng với React 19, Vite và Capacitor. Cho phép người dùng tạo, quản lý và tìm kiếm ghi chú dựa trên vị trí GPS với giao diện đẹp mắt và trải nghiệm người dùng tối ưu.

## ✨ Tính năng chính

### 🎯 Tính năng cốt lõi
- ✅ **Check-in thông minh**: Tạo ghi chú kèm tọa độ GPS chính xác cao
- ✅ **Phân loại ghi chú**: 6 danh mục với icon và màu sắc riêng biệt (Công việc, Cá nhân, Du lịch, Ẩm thực, Mua sắm, Khác)
- ✅ **Bản đồ tương tác**: Hiển thị ghi chú trên bản đồ Leaflet với marker tùy chỉnh
- ✅ **Địa chỉ tự động**: Tự động chuyển đổi tọa độ thành địa chỉ thực

### 🔍 Tính năng tìm kiếm và lọc nâng cao
- ✅ **Tìm kiếm thông minh**: Tìm kiếm trong nội dung ghi chú và địa chỉ
- ✅ **Lọc theo danh mục**: Lọc ghi chú theo từng loại cụ thể
- ✅ **Lọc theo khoảng cách**: Tùy chỉnh bán kính từ 100m đến 10km
- ✅ **Sắp xếp đa dạng**: Theo thời gian (mới/cũ) hoặc khoảng cách
- ✅ **Hiển thị khoảng cách**: Tính toán và hiển thị khoảng cách từ vị trí hiện tại

### 🗺️ Tích hợp bản đồ và dẫn đường
- ✅ **Bản đồ Leaflet**: Bản đồ mượt mà với khả năng zoom, pan
- ✅ **Marker tùy chỉnh**: Icon và màu sắc theo danh mục, hiệu ứng pulse cho vị trí hiện tại
- ✅ **Popup thông tin**: Hiển thị chi tiết ghi chú với các nút hành động
- ✅ **Dẫn đường thông minh**: Tự động mở Google Maps/Apple Maps tùy theo thiết bị
- ✅ **Auto-fit bounds**: Tự động điều chỉnh bản đồ để hiển thị tất cả ghi chú

### 📱 Trải nghiệm người dùng
- ✅ **Giao diện hiện đại**: Gradient background, glass morphism, animations
- ✅ **Responsive design**: Tối ưu hoàn hảo cho mobile và desktop
- ✅ **Dark theme**: Giao diện tối sang trọng với accent màu xanh
- ✅ **Micro-interactions**: Hover effects, loading states, transitions mượt mà
- ✅ **Accessibility**: Keyboard navigation, screen reader friendly

### 💾 Quản lý dữ liệu
- ✅ **Export/Import**: Xuất và nhập dữ liệu định dạng JSON
- ✅ **Copy tọa độ**: Sao chép tọa độ GPS vào clipboard
- ✅ **Dữ liệu mẫu**: Tích hợp sẵn dữ liệu demo để trải nghiệm
- ✅ **Xử lý lỗi**: Thông báo lỗi thân thiện và hướng dẫn khắc phục

## 🚀 Cài đặt và chạy

### Yêu cầu hệ thống
- Node.js 18+ 
- npm hoặc yarn
- Android Studio (cho Android)
- Xcode (cho iOS, chỉ trên macOS)

### 1. Clone và cài đặt
```bash
git clone <repository-url>
cd geo-notes
npm install
```

### 2. Chạy ứng dụng web (Development)
```bash
npm run dev
```
Ứng dụng sẽ chạy tại `http://localhost:5173`

### 3. Build production
```bash
npm run build
```

### 4. Preview production build
```bash
npm run preview
```

### 5. Build và deploy mobile
```bash
# Build và sync với Capacitor
npm run cap:build

# Mở Android Studio để build APK
npm run cap:android

# Mở Xcode để build iOS (chỉ trên macOS)
npm run cap:ios
```

## 📱 Cấu hình mobile

### Android
1. Cài đặt Android Studio và Android SDK
2. Chạy `npm run cap:android`
3. Thêm quyền location trong `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```
4. Build APK trong Android Studio hoặc chạy trên emulator

### iOS
1. Cài đặt Xcode (chỉ trên macOS)
2. Chạy `npm run cap:ios`
3. Thêm quyền location trong `ios/App/App/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Ứng dụng cần truy cập vị trí để tạo ghi chú theo vị trí</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Ứng dụng cần truy cập vị trí để tạo ghi chú theo vị trí</string>
```
4. Build và test trên iOS Simulator hoặc thiết bị thật

## 🛠️ Công nghệ sử dụng

### Frontend Stack
- **React 19**: Framework UI hiện đại với hooks và concurrent features
- **Vite**: Build tool nhanh với HMR và ES modules
- **JavaScript ES6+**: Syntax hiện đại với async/await, destructuring

### Mobile Development
- **Capacitor 7**: Cross-platform native runtime
- **@capacitor/geolocation**: Plugin GPS chính xác cao
- **PWA Ready**: Service worker và manifest cho Progressive Web App

### Maps & Location
- **Leaflet 1.9.4**: Thư viện bản đồ mã nguồn mở
- **OpenStreetMap**: Dữ liệu bản đồ miễn phí
- **BigDataCloud API**: Reverse geocoding để lấy địa chỉ

### Styling & UI
- **Tailwind CSS**: Utility-first CSS framework
- **CSS3 Advanced**: Gradients, backdrop-filter, animations
- **Glass Morphism**: Hiệu ứng kính mờ hiện đại
- **Custom Icons**: Emoji icons cho UX thân thiện

## 📋 Hướng dẫn sử dụng chi tiết

### 🎯 Tạo ghi chú mới
1. **Nhập nội dung**: Gõ mô tả ghi chú vào ô text area
2. **Chọn danh mục**: Chọn một trong 6 danh mục (Công việc, Cá nhân, Du lịch, Ẩm thực, Mua sắm, Khác)
3. **Check-in**: Nhấn nút danh mục tương ứng để lưu ghi chú với vị trí hiện tại
4. **Xác nhận vị trí**: Ứng dụng sẽ tự động lấy GPS và chuyển đổi thành địa chỉ

### 📱 Quản lý ghi chú
- **Xem chi tiết**: Click vào ghi chú để xem thông tin đầy đủ
- **Xóa ghi chú**: Hover vào ghi chú và nhấn nút 🗑️ (có xác nhận)
- **Copy tọa độ**: Nhấn "📋 Copy tọa độ" để sao chép GPS coordinates
- **Dẫn đường**: Nhấn "🗺️ Dẫn đường" để mở ứng dụng bản đồ native

### 🔍 Tìm kiếm và lọc nâng cao
1. **Mở bộ lọc**: Nhấn "🔍 Bộ lọc" để hiển thị panel tìm kiếm
2. **Tìm kiếm text**: Nhập từ khóa để tìm trong nội dung và địa chỉ
3. **Lọc danh mục**: Chọn danh mục cụ thể từ dropdown
4. **Sắp xếp**: Chọn sắp xếp theo thời gian hoặc khoảng cách
5. **Bán kính**: Kéo thanh trượt để điều chỉnh phạm vi tìm kiếm (100m-10km)

### 🗺️ Sử dụng bản đồ
1. **Chuyển chế độ**: Nhấn "🗺️ Bản đồ" để xem ghi chú trên map
2. **Tương tác**: Kéo để di chuyển, scroll để zoom in/out
3. **Xem chi tiết**: Click vào marker để hiển thị popup thông tin
4. **Chú thích**: Xem legend để hiểu ý nghĩa màu sắc và icon

### 💾 Quản lý dữ liệu
- **Xuất dữ liệu**: Nhấn "📤 Xuất dữ liệu" để download file JSON
- **Nhập dữ liệu**: Nhấn "📥 Nhập dữ liệu" và chọn file JSON hợp lệ
- **Backup tự động**: Dữ liệu được lưu tự động trong trình duyệt

## 🎨 Thiết kế UI/UX

### Design System
- **Color Palette**: Dark theme với gradient xanh-tím, accent màu xanh dương
- **Typography**: Font system mặc định với hierarchy rõ ràng
- **Spacing**: Grid system 8px với padding/margin nhất quán
- **Border Radius**: Rounded corners 12px-24px cho modern look

### Responsive Breakpoints
- **Mobile**: < 640px - Stack layout, touch-friendly buttons
- **Tablet**: 640px-1024px - Hybrid layout với sidebar
- **Desktop**: > 1024px - Full grid layout với sidebar cố định

### Animations & Interactions
- **Micro-interactions**: Button hover, loading states, transitions
- **Map animations**: Smooth zoom, marker bounce effects
- **Glass morphism**: Backdrop blur với transparency
- **Pulse effects**: Vị trí hiện tại với animation pulse

## 📦 Cấu trúc dự án

```
geo-notes/
├── src/
│   ├── App.jsx              # Component chính với tất cả logic
│   ├── main.jsx             # Entry point và React DOM render
│   └── index.css            # Global styles và Tailwind imports
├── public/
│   ├── index.html           # HTML template
│   └── vite.svg             # Favicon
├── android/                 # Capacitor Android project
├── ios/                     # Capacitor iOS project  
├── capacitor.config.json    # Cấu hình Capacitor
├── vite.config.js          # Cấu hình Vite build tool
├── package.json            # Dependencies và scripts
├── tailwind.config.js      # Tailwind CSS configuration
└── README.md               # Documentation
```

## 🔧 Development & Customization

### Thêm tính năng mới
1. **Tạo component**: Thêm component mới vào `App.jsx` hoặc tách riêng
2. **State management**: Sử dụng React hooks (useState, useEffect, useMemo)
3. **Styling**: Thêm Tailwind classes hoặc custom CSS
4. **Testing**: Test trên browser và mobile devices

### Customization Options
- **Thêm danh mục**: Modify `categories` array trong App.jsx
- **Thay đổi bản đồ**: Thay đổi tile layer trong LeafletMap component
- **Custom markers**: Modify `createIcon` function cho marker styles
- **API endpoints**: Thay đổi reverse geocoding service

### Performance Optimization
- **Lazy loading**: Components và maps được load khi cần
- **Memoization**: useMemo cho filtered/sorted data
- **Debouncing**: Search input với delay để giảm API calls
- **Image optimization**: Sử dụng WebP và responsive images

## 🚨 Troubleshooting

### Lỗi thường gặp
1. **Không lấy được vị trí**: Kiểm tra quyền location trong browser/device
2. **Bản đồ không hiển thị**: Kiểm tra internet connection và Leaflet CDN
3. **Build mobile thất bại**: Đảm bảo Android Studio/Xcode được cài đặt đúng
4. **Performance chậm**: Giảm số lượng ghi chú hoặc tăng filter radius

### Debug Tips
- Mở Developer Tools để xem console errors
- Kiểm tra Network tab cho API calls
- Test geolocation trên HTTPS (required cho production)
- Sử dụng mobile debugging tools cho mobile issues

## 🔮 Roadmap & Future Features

### Planned Features
- 🔄 **Offline support**: PWA với service worker
- 🌐 **Multi-language**: i18n support cho nhiều ngôn ngữ  
- 📊 **Analytics**: Thống kê usage và location patterns
- 🔐 **User accounts**: Authentication và cloud sync
- 📷 **Photo attachments**: Thêm ảnh vào ghi chú
- 🎯 **Geofencing**: Notifications khi đến gần ghi chú
- 📈 **Data visualization**: Charts và heatmaps
- 🤝 **Sharing**: Chia sẻ ghi chú với người khác

## 📄 License

MIT License - Tự do sử dụng, chỉnh sửa và phân phối.

## 🤝 Contributing

Chúng tôi hoan nghênh mọi đóng góp! 

### Cách đóng góp
1. Fork repository
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

### Bug Reports
- Sử dụng GitHub Issues để báo cáo bugs
- Cung cấp steps to reproduce và screenshots
- Ghi rõ browser/device và version

---

## 📞 Support & Contact

**Lưu ý quan trọng**: 
- Ứng dụng yêu cầu quyền truy cập vị trí để hoạt động
- Cần kết nối internet để load bản đồ và reverse geocoding
- Trên mobile, đảm bảo cấp quyền location cho ứng dụng
- Sử dụng HTTPS cho production để geolocation hoạt động

**Tính năng nổi bật**: Ứng dụng này không chỉ là một note-taking app thông thường mà là một công cụ quản lý vị trí thông minh với UI/UX hiện đại và nhiều tính năng nâng cao.