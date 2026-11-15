# Nouri

Natural-language health assistant: iOS + watchOS apps backed by Supabase.

| Folder | What |
|---|---|
| [`frontend/`](frontend/) | SwiftUI iOS app, watchOS app, shared `NouriKit` package |
| [`backend/`](backend/) | Supabase: migrations, RLS, Edge Functions |
| [`docs/`](docs/) | Architecture and security notes |

## Working split
- Frontend work stays in `frontend/`; backend work stays in `backend/`. Setup steps are in each folder's README.
- **Contract between the two:** the `ask` endpoint request/response shape and the metric names
  (`backend/supabase/functions/_shared/catalog.ts` ↔ `frontend/Packages/NouriKit/Sources/NouriKit/Models/MetricName.swift`).
  Change both sides in the same PR.
