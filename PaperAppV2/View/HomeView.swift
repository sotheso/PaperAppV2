//
//  HomeView.swift
//  PaperApp
//
//  Created by Sothesom on 24/09/1403.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
        BanereAval()
            .background(Color.gray.opacity(0.2))
            .navigationTitle("PaperApp")
            
        CardView()
        Spacer()
        }
    }
}

#Preview {
    HomeView()
}
