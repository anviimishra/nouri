// Metric whitelist shared by the planner prompt and query_metrics.
// Keep in sync with frontend/Packages/NouriKit/Sources/NouriKit/Models/MetricName.swift
export const METRICS = [
  "steps", "active_energy", "resting_hr", "hrv_sdnn", "vo2max", "weight",
  "body_fat", "respiratory_rate", "sleep_minutes", "mindful_minutes",
] as const;
export type Metric = typeof METRICS[number];
