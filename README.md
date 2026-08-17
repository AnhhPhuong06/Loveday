# 💖 LoveDay - Ứng Dụng Tình Yêu Toàn Diện (InLove + Locket + TikTok Streaks)

Ứng dụng Flutter dành cho các cặp đôi với đầy đủ các tính năng độc đáo:
1. **Đếm ngày yêu (InLove Style)**: Đếm ngày/giờ/phút/giây, nhịp tim bập bùng, đồng bộ avatar và ảnh bìa.
2. **Giữ chuỗi ảnh (TikTok & Locket Streaks 🔥)**: Chụp và gửi ảnh giữ chuỗi mỗi ngày, đồng hồ đếm ngược 24h, mở khóa danh hiệu khi chuỗi tăng cao.
3. **Theo dõi chu kỳ kinh nguyệt & Đồng bộ bạn trai**: Lịch dự đoán ngày rụng trứng, ngày an toàn, và lời nhắc nhở tinh tế cho bạn nam chăm sóc bạn gái.
4. **Nhắn tin đôi 1-1 Realtime**: Chat thời gian thực 0ms độ trễ qua Supabase Realtime WebSocket, sticker tình yêu, love notes.
5. **Dòng thời gian kỷ niệm**: Lưu giữ câu chuyện tình yêu, album ảnh chung.
6. **Đổi Icon App (Locket Style)**: Bộ sưu tập icon độc quyền (Golden Flame, Midnight Dark, Retro Pixel, Sakura...) thay đổi trực tiếp ngoài màn hình điện thoại.
7. **Đăng nhập 3 cổng**: Apple ID (iCloud), Google và Facebook + Ghép đôi bằng mã PIN 6 ký tự.

---

## 📁 Cấu Trúc Thư Mục Dự Án

```
d:\app\Loveday/
├── pubspec.yaml                 # Dependencies & Cấu hình thư viện Flutter
├── supabase/
│   └── schema.sql               # Script tạo Database Supabase 0đ (copy/paste 1 click)
├── lib/
│   ├── main.dart                # Điểm khởi chạy ứng dụng
│   ├── core/
│   │   ├── theme/               # Màu sắc Romantic, Dark Mode, Glassmorphism
│   │   └── services/            # Auth, Couple, Streak, Period, Chat, Dynamic Icon, Widget
│   ├── models/                  # UserModel, CoupleModel, StreakModel, PeriodModel, MessageModel, AppIconModel
│   ├── features/
│   │   ├── auth/                # Màn hình Đăng nhập (Apple, Google, FB) & Ghép đôi
│   │   ├── counter/             # Màn hình Đếm ngày yêu (InLove)
│   │   ├── streaks/             # Màn hình Chụp ảnh giữ chuỗi (Locket/TikTok)
│   │   ├── period/              # Màn hình Theo dõi chu kỳ kinh nguyệt
│   │   ├── chat/                # Màn hình Nhắn tin 1-1 Realtime
│   │   ├── memories/            # Màn hình Dòng thời gian kỷ niệm
│   │   ├── settings/            # Màn hình Đổi Icon App (Locket style)
│   │   └── home_shell_screen.dart # Thanh điều hướng Bottom Navigation 6 Tab
│   └── widgets/                 # Trái tim nhịp đập, Huy hiệu ngọn lửa, Thẻ gương
├── ios/Runner/Info.plist        # Cấu hình iOS Alternate Icons & Quyền Camera
└── android/app/src/main/AndroidManifest.xml # Cấu hình Android Activity Aliases & Quyền
```

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Ứng Dụng (0đ)

### Bước 1: Thiết lập Máy chủ 0đ trên Supabase
1. Truy cập [https://supabase.com](https://supabase.com) và bấm **Start your project** (Miễn phí 100%).
2. Đặt tên dự án (ví dụ `loveday-app`), chọn khu vực gần nhất (`Singapore`).
3. Vào mục **SQL Editor** ở thanh menu bên trái -> Bấm **New query**.
4. Mở tệp `supabase/schema.sql` trong dự án, copy toàn bộ nội dung và dán vào SQL Editor trên Supabase -> Bấm **Run**.
5. Vào **Project Settings** -> **API**:
   * Copy `Project URL` và `anon / public key`.
   * Mở file `lib/main.dart` và dán vào dòng `Supabase.initialize(url: '...', anonKey: '...')`.

### Bước 2: Cài đặt Flutter SDK (Nếu máy chưa có)
1. Tải Flutter SDK chính thức cho Windows tại: [https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip](https://flutter.dev)
2. Giải nén vào thư mục `C:\src\flutter` (hoặc `D:\flutter`).
3. Thêm đường dẫn `C:\src\flutter\bin` vào biến môi trường **Path (Environment Variables)** của Windows.
4. Mở Terminal kiểm tra:
   ```bash
   flutter doctor
   ```

### Bước 3: Chạy Ứng Dụng
Mở PowerShell tại thư mục `d:\app\Loveday`:
```bash
# Tải các gói thư viện
flutter pub get

# Chạy ứng dụng trên thiết bị (Điện thoại hoặc Giả lập Android/iOS/Chrome)
flutter run
```
