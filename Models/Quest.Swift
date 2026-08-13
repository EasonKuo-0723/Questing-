import Foundation

struct Quest: Identifiable, Codable {
    var id: String?
    var title: String
    var description: String
    var xpReward: Int
    var category: String
    var locationName: String
    var latitude: Double?
    var longitude: Double?
    var status: String // "open", "claimed", "completed"
    var createdBy: String
    var assignedTo: String?
    var createdAt: Date?

    // Convenience property for UI views using 'points'
    var points: Int {
        return xpReward
    }

    // Default initializer
    init(
        id: String? = UUID().uuidString,
        title: String,
        description: String,
        xpReward: Int = 100,
        category: String = "General",
        locationName: String = "Remote",
        latitude: Double? = nil,
        longitude: Double? = nil,
        status: String = "open",
        createdBy: String = "System",
        assignedTo: String? = nil,
        createdAt: Date? = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.xpReward = xpReward
        self.category = category
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.createdBy = createdBy
        self.assignedTo = assignedTo
        self.createdAt = createdAt
    }

    // MARK: - Starter Quests
    static var starterQuests: [Quest] [
        Quest(
            id: "tutorial-starter-01",
            title: "Claim This To Begin!",
            description: "Welcome to Questing! Tap 'Accept Quest' below to claim your first mission. Once accepted, head over to the '+' icon in the top right corner of the main Quests screen to post a quest of your own and earn your first badge!",
            xpReward: 100,
            category: "Tutorial",
            locationName: "App Tutorial",
            status: "open",
            createdBy: "Admin"
        ),
        Quest(
            id: "tutorial-starter-02",
            title: "Study Buddy Session",
            description: "Looking for someone to review algebra formulas with before tomorrow's quiz.",
            xpReward: 150,
            category: "Academics",
            locationName: "Library",
            status: "open",
            createdBy: "Admin"
        ),
        Quest(
            id: "tutorial-starter-03",
            title: "Campus Cleanup Challenge",
            description: "Spend 20 minutes collecting recyclable items around the outdoor courtyard.",
            xpReward: 200,
            category: "Events",
            locationName: "Courtyard",
            status: "open",
            createdBy: "Admin"
        )
    ]
}