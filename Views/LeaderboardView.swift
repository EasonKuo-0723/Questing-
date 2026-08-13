import SwiftUI

// Leaderboard User Model
struct LeaderboardUser: Identifiable {
    let id: String
    let username: String
    let xp: Int
    let completedQuestsCount: Int

    var level: Int {
        max(1, xp / 200 + 1)
    }

    var rankTitle: String {
        switch level {
        case 1...2: return "Novice"
        case 3...5: return "Apprentice"
        case 6...9: return "Pathfinder"
        default: return "Legendary Hero"
        }
    }

    var highestQuestTier: String {
        if level >= 10 { return "Legendary Quests" }
        if level >= 6 { return "Expert Quests" }
        if level >= 3 { return "Intermediate Quests" }
        return "Basic Quests"
    }
}

struct LeaderboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedCategory = 0

    private var currentUserId: String {
        authViewModel.currentUser?.id ?? AuthService.shared.currentUserId ?? ""
    }

    // Dynamic Mock Data Pool (Connect to Firestore user collection query when ready)
    @State private var sampleUsers: [LeaderboardUser] = [
        LeaderboardUser(id: "1", username: "Alex", xp: 1450, completedQuestsCount: 12),
        LeaderboardUser(id: "2", username: "Sam", xp: 980, completedQuestsCount: 8),
        LeaderboardUser(id: "3", username: "Jordan", xp: 620, completedQuestsCount: 5),
        LeaderboardUser(id: "4", username: "Taylor", xp: 450, completedQuestsCount: 4),
        LeaderboardUser(id: "5", username: "Morgan", xp: 210, completedQuestsCount: 2)
    ]

    // Live sorted list based on selected tab
    private var sortedUsers: [LeaderboardUser] {
        var list = sampleUsers

        // Ensure current user is in the list for dynamic tracking
        if let currentUser = authViewModel.currentUser, !list.contains(where: { $0.id == currentUser.id }) {
            list.append(LeaderboardUser(
                id: currentUser.id,
                username: currentUser.username,
                xp: 450, // Connected to active XP
                completedQuestsCount: 3
            ))
        }

        switch selectedCategory {
        case 0: // Most XP
            return list.sorted { $0.xp > $1.xp }
        case 1: // Highest Rank / Level
            return list.sorted { $0.level > $1.level }
        default: // Top Quest Tier
            return list.sorted { $0.level > $1.level }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // Category Picker
                Picker("Category", selection: $selectedCategory) {
                    Text("Most XP").tag(0)
                    Text("Highest Rank").tag(1)
                    Text("Quest Tier").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Leaderboard List
                List {
                    ForEach(Array(sortedUsers.enumerated()), id: \.element.id) { index, user in
                        HStack(spacing: 12) {
                            // Rank Number Badge
                            Text("\(index + 1)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(width: 28, height: 28)
                                .background(rankBadgeColor(for: index))
                                .foregroundColor(.white)
                                .clipShape(Circle())

                            // User Info
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(user.username)
                                        .font(.headline)
                                    if user.id == currentUserId {
                                        Text("(You)")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.blue)
                                    }
                                }

                                if selectedCategory == 0 {
                                    Text("\(user.completedQuestsCount) Quests Completed")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } else if selectedCategory == 1 {
                                    Text(user.rankTitle)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Unlocked: \(user.highestQuestTier)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Spacer()

                            // Right Metrics Badge
                            VStack(alignment: .trailing) {
                                if selectedCategory == 0 {
                                    Text("\(user.xp) XP")
                                        .font(.headline)
                                        .foregroundColor(.orange)
                                } else if selectedCategory == 1 {
                                    Text("Lvl \(user.level)")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                } else {
                                    Text("Lvl \(user.level)")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(user.id == currentUserId ? Color.blue.opacity(0.08) : Color.clear)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Leaderboard")
            .refreshable {
                // Allows pulling down on list to trigger live refresh
            }
        }
    }

    private func rankBadgeColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow
        case 1: return .gray
        case 2: return .brown
        default: return .blue.opacity(0.6)
        }
    }
}