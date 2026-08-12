import SwiftUI

@MainActor
class QuestViewModel: ObservableObject {
    @Published var quests: [Quest] = []
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var points: Int = 100
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetchQuests() async {
        isLoading = true
        errorMessage = nil
        do {
            self.quests = try await FirebaseService.shared.fetchQuests()
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func createQuest(creatorId: String) async -> Bool {
        guard !title.isEmpty, !description.isEmpty else {
            errorMessage = "Please enter both a title and description."
            return false
        }
        isLoading = true
        errorMessage = nil

        let newQuest = Quest(
            id: UUID().uuidString,
            title: title,
            description: description,
            points: points,
            createdBy: creatorId,
            createdAt: Date()
        )

        do {
            try await FirebaseService.shared.saveQuest(quest: newQuest)
            title = ""
            description = ""
            isLoading = false
            await fetchQuests()
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}