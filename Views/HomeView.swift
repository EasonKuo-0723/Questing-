import SwiftUI

struct HomeView: View {
    //  sample data for testing UI before connecting
    let sampleQuests = [
        Quest(id: "1", title: "Math Tutor", description: "Help with algebra for 1 hour.", xpReward: 100, category: "STEM", locationName: "2 Miles Away", latitude: nil, longitude: nil, status: "open", createdBy: "UserA", assignedTo: nil),
        Quest(id: "2", title: "Mow Lawn", description: "Mow the front lawn.", xpReward: 50, category: "Community", locationName: "1 Mile Away", latitude: nil, longitude: nil, status: "open", createdBy: "UserB", assignedTo: nil)
    ]
    
    var body: some View {
        NavigationView {
            List(sampleQuests, id: \.id) { quest in
                NavigationLink(destination: QuestDetailView(quest: quest)) {
                    VStack(alignment: .leading) {
                        Text(quest.title)
                            .font(.headline)
                        Text("\(quest.xpReward) XP • \(quest.locationName)")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Quests")
        }
    }
}
