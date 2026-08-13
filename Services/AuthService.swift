import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private init() {}

    // MARK: - Sign Up
    func signUp(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user.uid
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.uid
    }

    // MARK: - Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
    }

    // MARK: - Current User ID
    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
}
