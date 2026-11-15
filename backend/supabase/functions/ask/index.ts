// POST /ask { question } → { text, chart?, plan }
// Pipeline: auth → plan_cache → planner (Claude) → query_metrics RPC → answer templates → ask_log
import { corsHeaders } from "../_shared/cors.ts";

Deno.serve((req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  return new Response(JSON.stringify({ text: "Not implemented yet" }), {
    status: 501,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
});
