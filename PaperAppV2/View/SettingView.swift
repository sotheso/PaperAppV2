//
//  SettingView.swift
//  PaperApp
//
//  Created by Sothesom on 01/10/1403.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct SettingView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle(isOn: $isDarkMode) {
                        Label("حالت تاریک", systemImage: "moon.circle.fill")
                    }
                } header: {
                    Text("تنظیمات ظاهری")
                }
                
                Section {
                    Link(destination: URL(string: "https://yourwebsite.com/contact")!) {
                        Label("تماس با ما", systemImage: "envelope.fill")
                    }
                    
                    Link(destination: URL(string: "https://yourwebsite.com/privacy")!) {
                        Label("قوانین و مقررات", systemImage: "doc.text.fill")
                    }
                } header: {
                    Text("درباره ما")
                }
                
                Section {
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        Label("خروج از حساب کاربری", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("تنظیمات")
            .alert("آیا مطمئن هستید؟", isPresented: $showLogoutAlert) {
                Button("خیر", role: .cancel) {}
                Button("بله", role: .destructive) {
                    Task { // Wrap the signOut call in a Task
                        await signOut()
                    }
                }
            } message: {
                Text("شما در حال خروج از حساب کاربری خود هستید")
            }
        }
    }
    
    func signOut() async {
        do {
            // Sign out from Firebase
            try Auth.auth().signOut()
            
            // Sign out from Google
            GIDSignIn.sharedInstance.signOut()
            
            // Update login state on the main thread
            await MainActor.run {
              withAnimation {
                isLoggedIn = false
                 showLogoutAlert = false
              }
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
             await MainActor.run {
                // Optionally handle sign out errors here with UI updates
              }
        }
    }
}

#Preview {
    SettingView()
}
