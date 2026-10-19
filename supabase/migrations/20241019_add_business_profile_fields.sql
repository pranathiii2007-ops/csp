-- ============================================================
-- Migration: Add business profile fields to the profiles table
-- Run this in Supabase SQL Editor (Dashboard > SQL Editor > New query)
-- ============================================================

-- 1. Add new optional columns to the existing profiles table
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS logo_url     TEXT         DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS description  TEXT         DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS category     TEXT         DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS website      TEXT         DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS instagram    TEXT         DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS whatsapp     TEXT         DEFAULT NULL;

-- 2. Enable Row Level Security (if not already enabled)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies

-- Anyone can read profiles (needed so buyers see seller info on product pages)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Anyone can read profiles'
  ) THEN
    CREATE POLICY "Anyone can read profiles"
      ON profiles FOR SELECT
      USING (true);
  END IF;
END $$;

-- Only the authenticated owner can insert their own profile
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Sellers can create own profile'
  ) THEN
    CREATE POLICY "Sellers can create own profile"
      ON profiles FOR INSERT
      WITH CHECK (auth.uid() = id);
  END IF;
END $$;

-- Only the authenticated owner can update their own profile
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Sellers can update own profile'
  ) THEN
    CREATE POLICY "Sellers can update own profile"
      ON profiles FOR UPDATE
      USING (auth.uid() = id)
      WITH CHECK (auth.uid() = id);
  END IF;
END $$;

-- Only the authenticated owner can delete their own profile
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Sellers can delete own profile'
  ) THEN
    CREATE POLICY "Sellers can delete own profile"
      ON profiles FOR DELETE
      USING (auth.uid() = id);
  END IF;
END $$;

-- ============================================================
-- DONE. The app will now use these columns automatically.
-- ============================================================
