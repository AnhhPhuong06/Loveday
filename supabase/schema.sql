-- ==========================================================
-- LOVEDAY APP - SUPABASE DATABASE SCHEMA (0đ Serverless)
-- Copy toàn bộ nội dung này dán vào SQL Editor trên Supabase
-- ==========================================================

-- 1. Bảng USERS (Lưu thông tin hồ sơ người dùng)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    birth_date DATE,
    couple_id UUID,
    fcm_token TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Bảng COUPLES (Lưu thông tin không gian đôi & Đếm ngày & Chuỗi Streak)
CREATE TABLE IF NOT EXISTS public.couples (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invite_code VARCHAR(10) UNIQUE NOT NULL,
    user_1_id UUID NOT NULL REFERENCES public.profiles(id),
    user_2_id UUID REFERENCES public.profiles(id),
    anniversary_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    current_streak INT NOT NULL DEFAULT 0,
    max_streak INT NOT NULL DEFAULT 0,
    last_streak_date DATE,
    cover_image_url TEXT,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('pending', 'active', 'paused')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Thêm khóa ngoại couple_id cho profiles
ALTER TABLE public.profiles 
ADD CONSTRAINT fk_couple FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE SET NULL;

-- 3. Bảng STREAKS (Lưu các ảnh chụp giữ chuỗi hàng ngày giống Locket/TikTok)
CREATE TABLE IF NOT EXISTS public.streaks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.profiles(id),
    photo_url TEXT NOT NULL,
    caption TEXT,
    streak_day_count INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Bảng PERIOD_LOGS (Theo dõi chu kỳ kinh nguyệt & Đồng bộ thông báo cho bạn trai)
CREATE TABLE IF NOT EXISTS public.period_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE,
    cycle_length INT NOT NULL DEFAULT 28,  -- Độ dài chu kỳ (vd 28 ngày)
    period_length INT NOT NULL DEFAULT 5,  -- Độ dài ngày hành kinh (vd 5 ngày)
    symptoms JSONB DEFAULT '[]'::jsonb,    -- Triệu chứng: đau bụng, mệt mỏi, đau đầu...
    mood TEXT,                             -- Tâm trạng: vui, nhạy cảm, cáu kỉnh...
    notify_partner BOOLEAN DEFAULT true,   -- Cho phép báo cho người yêu
    note TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Bảng MESSAGES (Nhắn tin 1-1 Realtime)
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.profiles(id),
    text TEXT,
    media_url TEXT,
    type VARCHAR(20) DEFAULT 'text' CHECK (type IN ('text', 'image', 'voice', 'sticker', 'love_note')),
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Bảng MEMORIES (Dòng thời gian kỷ niệm & Album ảnh đôi)
CREATE TABLE IF NOT EXISTS public.memories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    photo_urls TEXT[] DEFAULT ARRAY[]::TEXT[],
    event_date DATE NOT NULL,
    category VARCHAR(50) DEFAULT 'anniversary',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Bật tính năng Realtime cho bảng messages và streaks
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.streaks;
ALTER PUBLICATION supabase_realtime ADD TABLE public.couples;

-- Bật Row Level Security (RLS) bảo mật dữ liệu riêng tư
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.period_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.memories ENABLE ROW LEVEL SECURITY;

-- Tạo Storage Bucket lưu trữ ảnh (Streaks, Memories, Avatars)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('couple-media', 'couple-media', true)
ON CONFLICT (id) DO NOTHING;
