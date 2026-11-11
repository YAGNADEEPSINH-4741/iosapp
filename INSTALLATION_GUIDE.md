# Trustify for iOS — Build & Installation Guide

This guide explains how to compile the Trustify iOS app (`.ipa`) via GitHub Actions and install it directly onto your connected iPhone from Windows.

---

## Architecture Overview

* **Main App (`TrustifyApp`):** Built with SwiftUI, provides Dashboard, Instant Dialpad Lookup, Voicemail audio player (via Supabase), Noted Numbers notepad, and Trusted Callers whitelist.
* **CallKit Extension (`TrustifyCallDirectory`):** Native `CXCallDirectoryProvider` extension that registers verified caller IDs (Emergency 112/100, Major Banks, Swiggy, Zomato, Amazon Delivery, etc.) and blocks spam prefixes directly in the iOS native incoming call screen.

---

## Step 1: Push Code to GitHub

From `d:\test-repo\iosapp`, commit and push to a GitHub repository:

```powershell
cd d:\test-repo\iosapp
git add .
git commit -m "Initial commit for Trustify iOS"
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/trustify-ios.git
git push -u origin main
```

---

## Step 2: Download the Compiled IPA

1. Navigate to your GitHub repository in your browser.
2. Click the **Actions** tab.
3. Select the latest workflow run: **"Build Trustify iOS IPA"**.
4. Once completed (typically ~2 minutes), scroll down to **Artifacts** and download **`Trustify-iOS-IPA`**.
5. Unzip the downloaded file to find `Trustify.ipa`.

---

## Step 3: Sideload onto Connected iPhone using Sideloadly (Windows)

Since your iPhone is already connected via USB:

1. **Download & Install Sideloadly:**
   - Download the free Windows 64-bit installer from [https://sideloadly.io](https://sideloadly.io).
   - Ensure iTunes / Apple Mobile Device Support is installed (Windows recognizes your connected Apple iPhone).

2. **Connect & Sideload:**
   - Launch **Sideloadly**.
   - Your connected iPhone should appear automatically under **iDevice**.
   - Drag and drop `Trustify.ipa` into the IPA icon area in Sideloadly.
   - Enter your **Apple ID** (used only to generate a free 7-day personal development certificate directly with Apple).
   - Click **Start**. Sideloadly will sign and install Trustify directly onto your iPhone.

---

## Step 4: First-Time Setup on Your iPhone

1. **Trust Developer Certificate:**
   - Go to **Settings > General > VPN & Device Management**.
   - Under *Developer App*, tap your Apple ID and tap **Trust**.

2. **Enable Caller ID & Spam Blocking in iOS:**
   - Go to **Settings > Phone > Call Blocking & Identification**.
   - Turn **ON** the toggle for **Trustify**.
   - iOS will now display *"Trustify: Verified Courier"*, *"Trustify: HDFC Bank Helpline"*, etc., directly on your incoming phone calls!

