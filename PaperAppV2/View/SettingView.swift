//
//  SettingView.swift
//  PaperApp
//
//  Created by Sothesom on 01/10/1403.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
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
                        // Add logout action here
                    }) {
                        Label("خروج از حساب کاربری", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("تنظیمات")
        }
    }
}

#Preview {
    SettingView()
}
