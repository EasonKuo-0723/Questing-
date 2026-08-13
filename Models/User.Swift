import Foundation

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var xp: Int
    var level: Int
    var rankTitle: String
    var completedQuestsCount: Int
    var postedQuestsCount: Int
    var activeQuestIds: [String]
    var avatarCustomization: [String: String]?
    var createdAt: Date?

    // Convenience computed property for views using 'username'
    var username: String {
        return name
    }

    // Default initializer
    init(
        id: String,
        name: String,
        email: String,
        xp: Int = 0,
        level: Int = 1,
        rankTitle: String = "Novice Adventurer",
        completedQuestsCount: Int = 0,
        postedQuestsCount: Int = 0,
        activeQuestIds: [String] = [],
        avatarCustomization: [String: String]? = nil,
        createdAt: Date? = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.xp = xp
        self.level = level
        self.rankTitle = rankTitle
        self.completedQuestsCount = completedQuestsCount
        self.postedQuestsCount = postedQuestsCount
        self.activeQuestIds = activeQuestIds
        self.avatarCustomization = avatarCustomization
        self.createdAt = createdAt
    }

    // Helper method to calculate rank based on XP
    static func calculateRank(for xp: Int) -> (level: Int, title: String) {
        let level = max(1, xp / 200 + 1)
        let title: String
        switch level {
        case 1...2: title = "Novice Adventurer"
        case 3...5: title = "Adept Apprentice"
        case 6...9: title = "Veteran Pathfinder"
        default: title = "Legendary Hero"
        }
        return (level, title)
    }
}
