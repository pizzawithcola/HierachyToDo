//
//  SignInButton.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/4/13.
//

import SwiftUI
import AuthenticationServices

struct SignInButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(ModelData.self) var modelData
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var body: some View {
        SignInWithAppleButton(.signIn,
                              onRequest: configureRequest,
                              onCompletion: handleAuthorization
        )
        .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
        )
        .frame(height: 45)
        .padding()
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: { Text(alertMessage) }

    }
    
    private func configureRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    private func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
               let fullName = appleIDCredential.fullName,
               let email = appleIDCredential.email{
                
                modelData.login(email: email, fName: fullName.givenName ?? "first name", lName: fullName.familyName ?? "last name")
                if !modelData.save() {
                    showAlert = true
                    alertTitle = "Warning"
                    alertMessage = "Failed to save."
                }
            } else {
                showAlert = true
                alertTitle = "Unexpected Result"
                alertMessage = "\(authResults)"
            }
        case .failure(let error):
            showAlert = true
            alertTitle = "Authentication Failed"
            alertMessage = "\(error)"
        }
    }
}

#Preview {
    SignInButton().environment(ModelData())
}
