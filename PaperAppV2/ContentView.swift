//
//  ContentView.swift
//  PaperAppV2
//
//  Created by Sothesom on 02/10/1403.
// 586752234501-2gjvgq6hh6jishobkoa623hhfdlf7ld2.apps.googleusercontent.com

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some View {
        VStack {
            FirebaseLog(isLoggedIn: $isLoggedIn)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

