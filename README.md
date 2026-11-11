# Trustify (SafeCall AI) for iOS

Cross-platform iOS counterpart to Trustify Android. Engineered with native CallKit integration, on-device offline directories, Supabase web voicemail integration, and a number notepad.

## Features
- **CallKit Extension:** Integrates directly with the native iOS Phone app to display verified badges for banks, emergency numbers, and delivery couriers.
- **Instant Lookup & Dialpad:** In-app T9 / number lookup with TRAI series classification (140, 1600, 1800, 1860).
- **Web Voicemails:** Inline visual voicemail audio player connecting to Supabase storage.
- **Noted Numbers:** Quick notepad for delivery OTPs, tracking IDs, and reference numbers with 1-tap clipboard copy.
- **Trusted Callers:** Custom whitelist management.

## Project Structure
- `Sources/Shared/`: Models and deterministic engines (TRAI series classifier, Offline directory).
- `Sources/TrustifyApp/`: Modern SwiftUI application.
- `Sources/TrustifyCallDirectory/`: `CXCallDirectoryProvider` extension.
- `.github/workflows/build-ios.yml`: Cloud CI/CD to build `.ipa` on macOS runners.
- `project.yml`: XcodeGen project configuration.

