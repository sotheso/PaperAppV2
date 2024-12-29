//
//  ViewHomeS.swift
//  PaperAppV2
//
//  Created by Sothesom on 09/10/1403.
//

import SwiftUI

struct Item: Identifiable {
    var id: String = UUID().uuidString
    var color: Color
}

var mackItems: [Item] = [
    .init(color: .blue),
    .init(color: .red),
    .init(color: .green),
    .init(color: .orange),
    .init(color: .purple)
]

struct ViewHomeS: View {
    @State private var activePage: Int = 0
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 15){
                ViewHomeS1(activeIndex: $activePage){
                    ForEach(mackItems){ item in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.color.gradient)
                            .padding(.horizontal, 15)
                    }
                }
                .frame(height: 220)
                
                HStack(spacing: 5) {
                    ForEach(mackItems.indices, id: \.self) { index in
                        Circle()
                            .fill(activePage == index ? .primary : .secondary)
                            .frame(width: 8, height: 8)
                    }
                }
                .animation(.snappy, value: activePage)
            }
            .navigationTitle("Auto Scrool")
        }
    }
}

#Preview {
    ViewHomeS()
}
