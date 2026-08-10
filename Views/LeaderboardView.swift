import SwiftUI

struct LeaderboardView: View {
    
    // Fake leaderboard data
    let players: [LeaderboardPlayer] = [
        LeaderboardPlayer(
            name: "Alex",
            level: 15,
            xp: 15200
        ),
        
        LeaderboardPlayer(
            name: "Sarah",
            level: 14,
            xp: 13850
        ),
        
        LeaderboardPlayer(
            name: "David",
            level: 12,
            xp: 11400
        ),
        
        LeaderboardPlayer(
            name: "Eason",
            level: 10,
            xp: 9750
        ),
        
        LeaderboardPlayer(
            name: "James",
            level: 9,
            xp: 8200
        ),
        
        LeaderboardPlayer(
            name: "Emily",
            level: 8,
            xp: 7600
        ),
        
        LeaderboardPlayer(
            name: "Daniel",
            level: 7,
            xp: 6900
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Top 3
                    if players.count >= 3 {
                        
                        HStack(
                            alignment: .bottom,
                            spacing: 10
                        ) {
                            
                            PodiumView(
                                player: players[1],
                                rank: 2,
                                color: .gray
                            )
                            
                            PodiumView(
                                player: players[0],
                                rank: 1,
                                color: .yellow
                            )
                            
                            PodiumView(
                                player: players[2],
                                rank: 3,
                                color: .brown
                            )
                        }
                        .padding(.top)
                    }
                    
                    // Ranking List
                    VStack(spacing: 12) {
                        
                        ForEach(
                            Array(players.enumerated()),
                            id: \.element.id
                        ) { index, player in
                            
                            LeaderboardRow(
                                rank: index + 1,
                                player: player,
                                isCurrentUser: player.name == "Eason"
                            )
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Leaderboard")
        }
    }
}


// MARK: - Player Model

struct LeaderboardPlayer: Identifiable {
    
    let id = UUID()
    
    let name: String
    let level: Int
    let xp: Int
}


// MARK: - Leaderboard Row

struct LeaderboardRow: View {
    
    let rank: Int
    let player: LeaderboardPlayer
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Rank
            Text(rankDisplay)
                .font(.title3)
                .fontWeight(.bold)
                .frame(width: 40)
            
            // Avatar
            Image(systemName: "person.circle.fill")
                .font(.system(size: 42))
                .foregroundStyle(
                    isCurrentUser ? .blue : .gray
                )
            
            // Player Information
            VStack(alignment: .leading, spacing: 4) {
                
                HStack {
                    Text(player.name)
                        .font(.headline)
                    
                    if isCurrentUser {
                        Text("YOU")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(.blue)
                            .clipShape(
                                Capsule()
                            )
                    }
                }
                
                Text("Level \(player.level)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // XP
            VStack(alignment: .trailing) {
                
                Text("\(player.xp)")
                    .fontWeight(.bold)
                
                Text("XP")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    isCurrentUser
                    ? Color.blue.opacity(0.12)
                    : Color(.secondarySystemBackground)
                )
        )
    }
    
    
    var rankDisplay: String {
        
        switch rank {
            
        case 1:
            return "🥇"
            
        case 2:
            return "🥈"
            
        case 3:
            return "🥉"
            
        default:
            return "\(rank)"
        }
    }
}


// MARK: - Podium View

struct PodiumView: View {
    
    let player: LeaderboardPlayer
    let rank: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            
            if rank == 1 {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
                    .font(.title2)
            }
            
            Image(systemName: "person.circle.fill")
                .font(
                    .system(
                        size: rank == 1 ? 65 : 50
                    )
                )
                .foregroundStyle(color)
            
            Text(player.name)
                .font(.headline)
            
            Text("\(player.xp) XP")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("#\(rank)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}


// MARK: - Preview

#Preview {
    LeaderboardView()
}