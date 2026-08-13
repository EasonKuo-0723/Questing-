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
}
