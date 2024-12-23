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

class AuthenticationViewModel: ObservableObject {
    // Your properties remain the same
    @Published var errorMessage = ""
    
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController
        else {
            // Move to main thread for updating @Published property
            await MainActor.run {
                self.errorMessage = "There is no root view controller"
            }
            print("There is no root view controller")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                throw AuthenticationError.tokenError(message: "ID token missing")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return true
        } catch {
            // Move to main thread for updating @Published property
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            print(error.localizedDescription)
            return false
        }
    }
}

// Rest of the file remains the same
enum AuthenticationError: Error {
    case tokenError(message: String)
}

