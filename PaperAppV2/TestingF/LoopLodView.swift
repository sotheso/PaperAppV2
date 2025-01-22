//
//  LoopLodView.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/11/1403.
//

import SwiftUI

struct LoopLodView: View {
    @State var appear = false
        
    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1)
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .frame(width: 44, height: 44)
            .rotationEffect(Angle(degrees: appear ? 360 : 0))
            .onAppear {
                withAnimation(
                    Animation
                        .linear(duration: 2)
                        .repeatForever(autoreverses: false)){
                    appear = true
                }
            }
    }
}

#Preview {
    LoopLodView()
}
