import Foundation
import Supabase

/// Reads and updates the signed-in user's onboarding state.
public protocol ProfileRepository: Sendable {
    func isOnboarded() async throws -> Bool
    func markOnboarded(at date: Date) async throws
}

/// Stores onboarding state on the device. Used until sign-in (#11, #12) and the
/// `profiles` table (#9) are available; then the app switches to `SupabaseProfileRepository`.
public final class LocalProfileRepository: ProfileRepository, @unchecked Sendable {
    private let defaults: UserDefaults
    private let key = "nouri.onboardedAt"

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func isOnboarded() async throws -> Bool {
        defaults.object(forKey: key) as? Date != nil
    }

    public func markOnboarded(at date: Date) async throws {
        defaults.set(date, forKey: key)
    }
}

/// Reads and writes `profiles.onboarded_at` for the signed-in user. RLS limits it to their own row.
public struct SupabaseProfileRepository: ProfileRepository {
    private let client: SupabaseClient

    public init(client: SupabaseClient) {
        self.client = client
    }

    public func isOnboarded() async throws -> Bool {
        let userId = try await client.auth.session.user.id
        let profile: Profile = try await client.from("profiles")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
            .value
        return profile.onboardedAt != nil
    }

    public func markOnboarded(at date: Date) async throws {
        let userId = try await client.auth.session.user.id
        try await client.from("profiles")
            .update(["onboarded_at": date.ISO8601Format()])
            .eq("id", value: userId)
            .execute()
    }
}
