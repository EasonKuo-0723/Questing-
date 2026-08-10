import SwiftUI

struct ProfileView: View {
    
    // Fake profile data for now
    let username = "Eason"
    let level = 7
    let currentXP = 750
    let xpNeeded = 1000
    
    let questsCompleted = 23
    let moneyEarned = 145
    let currentStreak = 5
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Profile Picture
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .foregroundStyle(.blue)
                    
                    // Username
                    Text(username)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Level
                    Text("Level \(level)")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    
                    // XP Section
                    VStack(spacing: 8) {
                        
                        HStack {
                            Text("XP Progress")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(currentXP) / \(xpNeeded) XP")
                                .foregroundStyle(.secondary)
                        }
                        
                        ProgressView(
                            value: Double(currentXP),
                            total: Double(xpNeeded)
                        )
                        .tint(.blue)
                        .scaleEffect(x: 1, y: 2)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
                    
                    // Stats
                    HStack(spacing: 12) {
                        
                        StatCard(
                            icon: "checkmark.circle.fill",
                            value: "\(questsCompleted)",
                            title: "Quests",
                            color: .green
                        )
                        
                        StatCard(
                            icon: "dollarsign.circle.fill",
                            value: "$\(moneyEarned)",
                            title: "Earned",
                            color: .orange
                        )
                        
                        StatCard(
                            icon: "flame.fill",
                            value: "\(currentStreak)",
                            title: "Streak",
                            color: .red
                        )
                    }
                    
                    // Badges
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Badges")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            
                            BadgeView(
                                icon: "star.fill",
                                title: "Rookie",
                                color: .yellow
                            )
                            
                            Spacer()
                            
                            BadgeView(
                                icon: "flame.fill",
                                title: "Hot Streak",
                                color: .red
                            )
                            
                            Spacer()
                            
                            BadgeView(
                                icon: "trophy.fill",
                                title: "Winner",
                                color: .orange
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Recent Activity")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ActivityRow(
                            icon: "checkmark.circle.fill",
                            title: "Completed a quest",
                            subtitle: "+250 XP",
                            color: .green
                        )
                        
                        Divider()
                        
                        ActivityRow(
                            icon: "dollarsign.circle.fill",
                            title: "Earned quest reward",
                            subtitle: "+$20",
                            color: .orange
                        )
                        
                        Divider()
                        
                        ActivityRow(
                            icon: "arrow.up.circle.fill",
                            title: "Reached Level 7",
                            subtitle: "Level Up!",
                            color: .blue
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}


// MARK: - Stat Card

struct StatCard: View {
    
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}


// MARK: - Badge View

struct BadgeView: View {
    
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 65, height: 65)
                
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(color)
            }
            
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(width: 90)
    }
}


// MARK: - Activity Row

struct ActivityRow: View {
    
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                
                Text(title)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}


// MARK: - Preview

#Preview {
    ProfileView()
}