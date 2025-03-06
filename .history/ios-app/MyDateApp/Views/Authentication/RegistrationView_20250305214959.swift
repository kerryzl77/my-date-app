import SwiftUI

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var navigateToVerification: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .fontWeight(.medium)
                    
                    TextField("Enter your .edu email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .fontWeight(.medium)
                    
                    SecureField("Create a password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Password")
                        .fontWeight(.medium)
                    
                    SecureField("Confirm your password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                Button(action: registerUser) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Register")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(isLoading)
                
                NavigationLink(destination: VerificationView(email: email), isActive: $navigateToVerification) {
                    EmptyView()
                }
                
                Spacer()
                
                HStack {
                    Text("Already have an account?")
                    Button("Sign In") {
                        // Navigate to login screen
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
    
    private func registerUser() {
        // Reset error message
        errorMessage = ""
        
        // Validate inputs
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "All fields are required"
            return
        }
        
        guard email.hasSuffix(".edu") else {
            errorMessage = "Please use a valid .edu email"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters"
            return
        }
        
        // Show loading indicator
        isLoading = true
        
        // Call API to register user
        APIService.shared.register(email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success:
                    // Navigate to verification screen
                    navigateToVerification = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
} 