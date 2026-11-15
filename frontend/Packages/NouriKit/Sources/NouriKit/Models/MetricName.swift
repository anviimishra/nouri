import Foundation

/// Canonical metric identifiers shared by the apps and the backend catalog
/// (keep in sync with backend/supabase/functions/_shared/catalog.ts).
public enum MetricName: String, Codable, CaseIterable, Sendable {
    case steps
    case activeEnergy = "active_energy"
    case restingHR = "resting_hr"
    case hrvSDNN = "hrv_sdnn"
    case vo2Max = "vo2max"
    case weight
    case bodyFat = "body_fat"
    case respiratoryRate = "respiratory_rate"
    case sleepMinutes = "sleep_minutes"
    case mindfulMinutes = "mindful_minutes"
}
