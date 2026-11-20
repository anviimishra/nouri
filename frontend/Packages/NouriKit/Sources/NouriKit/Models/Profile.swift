import Foundation

/// A row in the `profiles` table (one per user, id = auth.users.id).
public struct Profile: Codable, Equatable, Sendable {
    public let id: UUID
    public var displayName: String?
    public var onboardedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case onboardedAt = "onboarded_at"
    }

    public init(id: UUID, displayName: String? = nil, onboardedAt: Date? = nil) {
        self.id = id
        self.displayName = displayName
        self.onboardedAt = onboardedAt
    }
}
