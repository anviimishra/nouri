# Nouri backend (Supabase)

## Prerequisites
- Docker Desktop (running)
- `brew install supabase/tap/supabase deno`

## Run locally
```bash
cd backend
cp supabase/functions/.env.example supabase/functions/.env   # add ANTHROPIC_API_KEY
supabase start          # local Postgres, Auth, Edge Runtime (prints anon key + URLs)
supabase db reset       # apply migrations + seed
supabase test db        # pgTAP tests in supabase/tests
supabase functions serve --env-file supabase/functions/.env
```

Give the frontend the `API URL` and `anon key` printed by `supabase start`
(they go in `frontend/Config/Secrets.xcconfig`).

## Layout
- `supabase/migrations/`: schema, RLS, `query_metrics` RPC (timestamped; never edit one that's been pushed, add a new one)
- `supabase/functions/ask/`: NL question → QueryPlan → query → answer
- `supabase/functions/_shared/catalog.ts`: metric whitelist (**keep in sync** with `frontend/.../MetricName.swift`)

## Sign in with Apple / Google
Disabled in `config.toml` until credentials exist. Set `enabled = true` and provide
`SUPABASE_AUTH_APPLE_SECRET`, `SUPABASE_AUTH_GOOGLE_CLIENT_ID`, `SUPABASE_AUTH_GOOGLE_SECRET` in `backend/supabase/.env`.
