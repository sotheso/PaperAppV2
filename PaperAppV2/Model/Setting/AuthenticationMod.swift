//
//  AuthenticationViewModel.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/10/1403.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthenticationMod: ObservableObject {
    @Published var errorMessage = ""
    
    @MainActor
    func signInWithGoogle() async -> Bool {
        // Reset any previous error
        self.errorMessage = ""
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorMessage = "No client ID found in Firebase configuration"
            return false
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "No root view controller found"
            return false
        }
        
        do {
            // Configure Google Sign In
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            // Attempt to restore previous sign-in
            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                print("Attempting to restore previous sign-in")
                _ = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            }
            
            // Perform sign in
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                self.errorMessage = "Failed to get ID token"
                return false
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            // Sign in to Firebase
            let authResult = try await Auth.auth().signIn(with: credential)
            print("Successfully signed in with Google as \(authResult.user.email ?? "unknown")")
            return true
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("Detailed sign in error: \(error)")
            
            // Remove the AuthErrorCode.Code check
            print("Error code: \((error as NSError).code)")
            return false
        }
    }
}

// Error enum remains the same
enum AuthenticationError: Error {
    case tokenError(message: String)
}
