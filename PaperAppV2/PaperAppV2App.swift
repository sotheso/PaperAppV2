//
//  PaperAppV2App.swift
//  PaperAppV2
//
//  Created by Sothesom on 02/10/1403.
//

// Your imports remain the same
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct PaperAppV2App: App {
    // Your properties remain the same
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    init() {
        // Configure Firebase first, before any other operations
        FirebaseApp.configure()
        
        // Configure Google Sign In
        if let clientID = FirebaseApp.app()?.options.clientID {
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            // Print debug information
            print("=== Firebase Configuration ====")
            print("Bundle ID: \(Bundle.main.bundleIdentifier ?? "Not found")")
            print("Client ID: \(clientID)")
            print("=============================")
        } else {
            print("❌ Failed to configure Google Sign In: No client ID found")
        }
    }

    // Your scene remains the same
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    AsliView()
                } else {
                    LogView(isLoggedIn: $isLoggedIn)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                }
            }
        }
    }
}
