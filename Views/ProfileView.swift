import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var questViewModel = QuestViewModel()

    // Fallback or user data
    private var username: String {
        authViewModel.currentUser?.username ?? "Quest Explorer"
    }

    private var email: String {
        authViewModel.currentUser?.email ?? "user@example.com"
    }

    private var currentUserId: String {
        authViewModel.currentUser?.id ?? AuthService.shared.currentUserId ?? ""
    }

    // Calculated Stats
    private var postedQuestsCount: Int {
        questViewModel.quests.filter { $0.createdBy == currentUserId }.count
    }

    // Mocked completed count (Wire to Firestore completed field when ready)
    private var completedQuestsCount: Int {
        3 
    }

    private var totalXP: Int {
        completedQuestsCount * 150
    }

    // Level & Rank Calculations
    private var currentLevel: Int {
        max(1, totalXP / 200 + 1)
    }

    private var userRank: String {
        switch currentLevel {
        case 1...2: return "Novice Adventurer"
        case 3...5: return "Adept Questing Apprentice"
        case 6...9: return "Veteran Pathfinder"
        default: return "Legendary Hero"
        }
    }

    private var xpForNextLevel: Int {
        currentLevel * 200
    }

    private var levelProgress: Double {
        let currentLevelBaseXP = (currentLevel - 1) * 200
        let xpInCurrentLevel = totalXP - currentLevelBaseXP
        return min(max(Double(xpInCurrentLevel) / 200.0, 0.0), 1.0)
    }

    // Allowed Quest Types based on Level
    private var accessibleQuestTypes: [String] {
        if currentLevel >= 5 {
            return ["General", "Academics", "Chores", "Events", "Sports", "Special Ops"]
        } else if currentLevel >= 3 {
            return ["General", "Academics", "Chores", "Events"]
        } else {
            return ["General", "Academics", "Chores"]
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header Card
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)

                        VStack(spacing: 4) {
                            Text(username)
                                .font(.title2)
                                .bold()
                            
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text(userRank)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)

                    // Level & XP Progress Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Level \(currentLevel)")
                                .font(.headline)
                                .bold()
                            Spacer()
                            Text("\(totalXP) / \(xpForNextLevel) XP")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        ProgressView(value: levelProgress)
                            .tint(.blue)

                        Text("\(xpForNextLevel - totalXP) XP needed for Level \(currentLevel + 1)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)

                    // Stats Grid Card
                    HStack(spacing: 16) {
                        VStack {
                            Text("\(completedQuestsCount)")
                                .font(.title)
                                .bold()
                                .foregroundColor(.green)
                            Text("Completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)

                        VStack {
                            Text("\(postedQuestsCount)")
                                .font(.title)
                                .bold()
                                .foregroundColor(.orange)
                            Text("Posted")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }

                    // Available Quest Categories Access Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Unlocked Quest Types")
                            .font(.headline)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                            ForEach(accessibleQuestTypes, id: \.self) { category in
                                Text(category)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green.opacity(0.15))
                                    .foregroundColor(.green)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)

                    // Sign Out Button
                    Button(role: .destructive, action: {
                        authViewModel.signOut()
                    }) {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("Profile")
            .task {
                await questViewModel.fetchQuests()
            }
        }
    }
}