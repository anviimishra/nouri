# Nouri frontend (iOS + watchOS)

## Prerequisites
- **Xcode 16+** (Swift 6; required by supabase-swift)
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

## TODO after upgrading to Xcode 16
Uncomment the supabase-swift dependency in `Packages/NouriKit/Package.swift`.
