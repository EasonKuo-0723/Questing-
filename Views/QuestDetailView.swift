import SwiftUI

struct QuestDetailView: View {
    let quest: Quest
    @State private var isAccepted = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(quest.title)
                .font(.largeTitle)
            
            Text("Category: \(quest.category)")
            Text("Reward: \(quest.xpReward) XP")
            Text("Location: \(quest.locationName)")
            
            Text(quest.description)
                .padding()
            
            Button(action: {
                isAccepted = true
            }) {
                Text(isAccepted ? "Accepted!" : "Accept Quest")
                    .padding()
                    .background(isAccepted ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isAccepted)
            
            Spacer()
        }
        .padding()
    }
}
