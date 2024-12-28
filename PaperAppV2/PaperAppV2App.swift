//
//  PaperAppV2App.swift
//  PaperAppV2
//
//  Created by Sothesom on 02/10/1403.
//

// Your imports remain the same
// Your imports remain the same
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseStorage // Add this import
import GoogleSignIn

@main
struct PaperAppV2App: App {
    // Rest of the code remains the same
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    init() {
        // Rest of the init code remains the same
        FirebaseApp.configure()
        
        if let clientID = FirebaseApp.app()?.options.clientID {
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
        }
    }

    var body: some Scene {
        // Body code remains the same
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    AsliView()
                } else {
                    LogView(isLoggedIn: $isLoggedIn)
                }
            }
        }
    }
}
