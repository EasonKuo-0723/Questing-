import SwiftUI

struct SignUpView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Text("Create Account")
                    .font(.largeTitle)
                    .bold()

                // Username
                TextField(
                    "Username",
                    text: $authViewModel.username
                )
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)

                // Email
                TextField(
                    "Email",
                    text: $authViewModel.email
                )
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

                // Password
                SecureField(
                    "Password",
                    text: $authViewModel.password
                )
                .textFieldStyle(.roundedBorder)

                // Error message
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // Sign Up Button
                Button {
                    Task {
                        await authViewModel.signUp()
                    }
                } label: {

                    if authViewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                // Back to login
                Button("Already have an account? Log In") {
                    dismiss()
                }
                .padding(.top)
            }
            .padding()
        }
    }
}
