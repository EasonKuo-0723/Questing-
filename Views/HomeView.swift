import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var questViewModel = QuestViewModel()
    @State private var showCreateQuest = false

    var body: some View {
        NavigationView {
            Group {
                if questViewModel.isLoading && questViewModel.quests.isEmpty {
                    ProgressView("Loading Quests...")
                } else if questViewModel.quests.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "flag.slash")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No active quests found")
                            .font(.headline)
                        Button("Create One") {
                            showCreateQuest = true
                        }
                    }
                } else {
                    List(questViewModel.quests) { quest in
                        NavigationLink(destination: QuestDetailView(quest: quest)) {
                            VStack(alignment: .leading) {
                                Text(quest.title)
                                    .font(.headline)
                                Text("\(quest.points) XP • \(quest.description)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Quests")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        authViewModel.signOut()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCreateQuest = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateQuest) {
                CreateQuestView()
            }
            .task {
                await questViewModel.fetchQuests()
            }
        }
    }
}
