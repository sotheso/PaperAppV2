//
//  ContentView.swift
//  PaperAppV2
//
//  Created by Sothesom on 02/10/1403.

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some View {
        VStack {
            LogView(isLoggedIn: $isLoggedIn)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

