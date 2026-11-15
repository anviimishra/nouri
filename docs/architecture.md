# Architecture

- `frontend/`: SwiftUI iOS + watchOS apps; shared code in `NouriKit`.
- `backend/`: Supabase (Postgres + RLS, Auth with Apple/Google, Edge Functions).
- The `ask` Edge Function turns a question into a typed QueryPlan (Claude), runs it through the
  whitelisted `query_metrics` RPC, and answers with deterministic templates.
