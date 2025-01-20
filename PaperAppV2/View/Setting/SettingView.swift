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
    // اضافه کردن متغیر برای نمایش آلرت تماس با ما
    @State private var showContactAlert = false
    
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
                    Button(action: {
                        showContactAlert = true
                    }) {
                        Label("تماس با ما", systemImage: "paperplane.circle.fill")
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
            // آلرت خروج از حساب کاربری
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
            // اضافه کردن آلرت جدید برای تماس با ما
            .alert("انتخاب نحوه ارتباط", isPresented: $showContactAlert) {
                Button("تلگرام") {
                    if let url = URL(string: "https://t.me/sothesom") {
                        UIApplication.shared.open(url)
                    }
                }
                Button("اینستاگرام") {
                    if let url = URL(string: "https://www.instagram.com/sothesom") {
                        UIApplication.shared.open(url)
                    }
                }
                Button("تماس تلفنی") {
                    if let url = URL(string: "tel:+989123456789"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("لغو", role: .cancel) {}
            } message: {
                Text("لطفاً روش ارتباطی مورد نظر خود را انتخاب کنید")
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
