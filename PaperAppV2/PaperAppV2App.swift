//
//  PaperAppV2App.swift
//  PaperAppV2
//
//  Created by Sothesom on 02/10/1403.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

@main
struct PaperAppV2App: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    init() {
        // Only configure Firebase, remove emulator
        FirebaseApp.configure()
        // Remove this line
        // Auth.auth().useEmulator(withHost:"Localhost", port: 9099)
    }

    // Rest of your code remains the same
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    AsliView()
                } else {
                    FirebaseLog(isLoggedIn: $isLoggedIn)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                }
            }
        }
    }
}

