# Security & PHI

- RLS on every user table (`user_id = auth.uid()`).
- Only daily aggregates leave the device; no raw HealthKit samples.
- The LLM never receives health values; `ask_log` stores no question text or results.
- Before Iteration 2 (health records): Supabase HIPAA add-on + BAA, Anthropic BAA/ZDR, column encryption.
