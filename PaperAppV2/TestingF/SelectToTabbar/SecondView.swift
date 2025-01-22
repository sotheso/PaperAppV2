//
//  SecondView.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/11/1403.
//

import SwiftUI

struct SecondView: View {
    @Binding var tabSelection: Int
    var body: some View {
        Text("Second View")
            .onTapGesture {
                tabSelection = 1
            }
    }
}


#Preview {
    SecondView(tabSelection: .constant(2))
}
