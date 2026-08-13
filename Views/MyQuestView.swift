import SwiftUI

struct MyQuestView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var questViewModel = QuestViewModel()
    @State private var selectedTab = 0

    var currentUserId: String {
        authViewModel.currentUser?.id ?? AuthService.shared.currentUserId ?? ""
    }

    var postedQuests: [Quest] {
        questViewModel.quests.filter { $0.createdBy == currentUserId }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Quest Filter", selection: $selectedTab) {
                    Text("Posted (\(postedQuests.count))").tag(0)
                    Text("Accepted").tag(1)
                    Text("Completed").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if questViewModel.isLoading {
                    Spacer()
                    ProgressView("Loading quests...")
                    Spacer()
                } else {
                    List {
                        if selectedTab == 0 {
                            if postedQuests.isEmpty {
                                Text("You haven't posted any quests yet.")
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(postedQuests) { quest in
                                    NavigationLink(destination: QuestDetailView(quest: quest)) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(quest.title)
                                                .font(.headline)
                                            Text("\(quest.points) XP • \(quest.description)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                            }
                        } else if selectedTab == 1 {
                            Text("No accepted quests active.")
                                .foregroundColor(.secondary)
                        } else {
                            Text("No completed quests yet.")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("My Quests")
            .task {
                await questViewModel.fetchQuests()
            }
        }
    }
}