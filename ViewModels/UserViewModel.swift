import SwiftUI

@MainActor
class UserViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var leaderboardUsers: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Computed Properties for XP & Ranking

    var currentXP: Int {
        currentUser?.xp ?? 0
    }

    var currentLevel: Int {
        max(1, currentXP / 200 + 1)
    }

    var userRankTitle: String {
        switch currentLevel {
        case 1...2: return "Novice Adventurer"
        case 3...5: return "Adept Apprentice"
        case 6...9: return "Veteran Pathfinder"
        default: return "Legendary Hero"
        }
    }

    var xpForNextLevel: Int {
        currentLevel * 200
    }

    var levelProgress: Double {
        let currentLevelBaseXP = (currentLevel - 1) * 200
        let xpInCurrentLevel = currentXP - currentLevelBaseXP
        return min(max(Double(xpInCurrentLevel) / 200.0, 0.0), 1.0)
    }

    var unlockedQuestCategories: [String] {
        if currentLevel >= 5 {
            return ["General", "Academics", "Chores", "Events", "Sports", "Special Ops"]
        } else if currentLevel >= 3 {
            return ["General", "Academics", "Chores", "Events"]
        } else {
            return ["General", "Academics", "Chores"]
        }
    }

    // MARK: - User Operations

    /// Fetch profile data for a specific user ID
    func fetchUserProfile(userId: String) async {
        isLoading = true
        errorMessage = nil
        do {
            self.currentUser = try await FirebaseService.shared.fetchUser(userId: userId)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Add XP to the user when they complete a quest
    func addXP(points: Int) async {
        guard var user = currentUser else { return }
        user.xp += points
        
        do {
            try await FirebaseService.shared.saveUser(user: user)
            self.currentUser = user
        } catch {
            self.errorMessage = "Failed to update XP: \(error.localizedDescription)"
        }
    }

    /// Fetch all users for Leaderboard display
    func fetchLeaderboard() async {
        isLoading = true
        errorMessage = nil
        do {
            // Note: Update FirebaseService to include fetchAllUsers() when wiring live leaderboard queries
            // self.leaderboardUsers = try await FirebaseService.shared.fetchAllUsers()
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}