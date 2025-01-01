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
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isLoggedIn") private var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var appLoadComplete = false // Added a new state to control initial load
    
    init() {
        FirebaseApp.configure()
        
        if let clientID = FirebaseApp.app()?.options.clientID {
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
        }
    }

    var body: some Scene {
        WindowGroup {
            if appLoadComplete {
                if isLoggedIn {
                    AsliView()
                } else {
                    IntroView0(isLoggedIn: $isLoggedIn)  
                }
            } else {
                ProgressView().onAppear {
                    appLoadComplete = true
                }
            }
        }
    }
}

