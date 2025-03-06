import SwiftUI

struct VerificationView: View {
    let email: String
    @State private var verificationCode: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var navigateToEventSelection: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Verify Your Email")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Text("We've sent a verification code to \(email)")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Verification Code")
                    .fontWeight(.medium)
                
                TextField("Enter 6-digit code", text: $verificationCode)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            Button(action: verifyCode) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Verify")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(isLoading)
            
            Button("Resend Code") {
                resendVerificationCode()
            }
            .padding(.top, 10)
            
            NavigationLink(destination: EventSelectionView(), isActive: $navigateToEventSelection) {
                EmptyView()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Verification", displayMode: .inline)
    }
    
    private func verifyCode() {
        // Reset error message
        errorMessage = ""
        
        // Validate verification code
        guard verificationCode.count == 6, Int(verificationCode) != nil else {
            errorMessage = "Please enter a valid 6-digit code"
            return
        }
        
        // Show loading indicator
        isLoading = true
        
        // Call API to verify code
        APIService.shared.verifyEmail(email: email, code: verificationCode) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success:
                    // Navigate to event selection screen
                    navigateToEventSelection = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func resendVerificationCode() {
        APIService.shared.resendVerificationCode(email: email) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Show success message
                    errorMessage = "Verification code resent"
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(email: "student@university.edu")
    }
}