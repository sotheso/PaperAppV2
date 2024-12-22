//
//  PaperAppV2App.swift
//  PaperAppV2
//
//  Created by Sothesom on 02/10/1403.
//

import SwiftUI
import Firebase

@main
struct PaperAppV2App: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    init() {
            FirebaseApp.configure()
        }

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

