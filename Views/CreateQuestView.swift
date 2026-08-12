import SwiftUI

struct CreateQuestView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var questViewModel = QuestViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Quest Details")) {
                    TextField("Title", text: $questViewModel.title)
                    TextEditor(text: $questViewModel.description)
                        .frame(height: 100)
                    Stepper("Reward Points: \(questViewModel.points)", value: $questViewModel.points, in: 10...1000, step: 10)
                }

                if let error = questViewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                Section {
                    Button(action: {
                        Task {
                            guard let userId = authViewModel.currentUser?.id ?? AuthService.shared.currentUserId else { return }
                            let success = await questViewModel.createQuest(creatorId: userId)
                            if success {
                                dismiss()
                            }
                        }
                    }) {
                        if questViewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Post Quest")
                                .frame(maxWidth: .infinity)
                                .alignmentGuide(.leading) { $0[.leading] }
                        }
                    }
                }
            }
            .navigationTitle("New Quest")
        }
    }
}