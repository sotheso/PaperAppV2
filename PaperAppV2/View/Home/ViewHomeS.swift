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
    var body: some View {
        NavigationStack{
            VStack{
                ViewHomeS1{
                    ForEach(mackItems){ item in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.color.gradient)
                            .padding(.horizontal, 15)
                    }
                }
                .frame(height: 220)
            }
            .navigationTitle("Auto Scrool")
        }
    }
}

#Preview {
    ViewHomeS()
}
