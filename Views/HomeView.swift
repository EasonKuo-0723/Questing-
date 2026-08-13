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
                    List(questViewModel.quests, id: \.id) { quest in
                        NavigationLink {
                            QuestDetailView(quest: quest)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(quest.title)
                                    .font(.headline)

                                Text("\(quest.xpReward) XP • \(quest.description)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
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
