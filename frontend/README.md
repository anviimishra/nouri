# Nouri frontend (iOS + watchOS)

## Prerequisites
- **Xcode 27+** (Swift 6.4), with the iOS 27 and watchOS 27 simulators installed
  (`xcodebuild -downloadPlatform iOS` / `xcodebuild -downloadPlatform watchOS`)
- `brew install xcodegen`

## Run
```bash
cd frontend
cp Config/Secrets.xcconfig.example Config/Secrets.xcconfig   # team id, Supabase anon key, Google client id
xcodegen                 # generates Nouri.xcodeproj from project.yml (the .xcodeproj is git-ignored)
open Nouri.xcodeproj
```
Re-run `xcodegen` after pulling or after adding/removing files. Edit `project.yml`, not the project file.

## Layout
- `Nouri/`: iOS app target (HealthKit sync, Google Sign-In, all iPhone UI)
- `NouriWatch/`: watchOS app target
- `Packages/NouriKit/`: shared by both: models, networking, auth, Ask client.
  `MetricName.swift` must match `backend/supabase/functions/_shared/catalog.ts`.

## Build and test from the command line
```bash
xcodebuild -project Nouri.xcodeproj -scheme Nouri \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project Nouri.xcodeproj -scheme NouriWatch \
  -destination 'platform=watchOS Simulator,name=Apple Watch Series 12 (46mm)' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project Nouri.xcodeproj -scheme Nouri \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro' CODE_SIGNING_ALLOWED=NO -only-testing:NouriTests test
(cd Packages/NouriKit && swift test)
```
`CODE_SIGNING_ALLOWED=NO` builds for the simulator without an Apple Developer team. Running on a real device
(and HealthKit / Sign in with Apple) needs `DEVELOPMENT_TEAM` in `Config/Secrets.xcconfig`.
