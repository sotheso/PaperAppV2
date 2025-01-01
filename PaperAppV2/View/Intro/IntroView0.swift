//
//  Intro.swift
//  PaperAppV2
//
//  Created by Sothesom on 09/10/1403.
//

import SwiftUI
// Your imports remain the same

struct IntroView0: View {
    @Binding var isLoggedIn: Bool  // Add this
    
    var body: some View {
        IntroView1(isLoggedIn: $isLoggedIn)  // Pass binding
            .environment(\.colorScheme, .dark)
    }
}

// Update Preview
#Preview {
    IntroView0(isLoggedIn: .constant(false))
}
