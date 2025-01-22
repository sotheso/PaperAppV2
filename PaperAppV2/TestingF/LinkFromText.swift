//
//  LinkFromText.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/11/1403.
//

import SwiftUI

struct LinkFromText: View {
    var body: some View {
        HStack{
            Text("Go to")
            Text("Sothesom Page")
                .foregroundColor(Color.blue)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://t.me/sothesom")!)
                }
        }
    }
}

#Preview {
    LinkFromText()
}
