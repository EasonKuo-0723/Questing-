import Foundation
import SwiftUI
import Combine

@MainActor
class UserViewModel: ObservableObject {

    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadUser(userId: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await FirebaseService.shared.fetchUser(userId: userId)
            self.currentUser = user
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
