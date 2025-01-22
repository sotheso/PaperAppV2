//
//  oneView.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/11/1403.
//

import SwiftUI

struct oneView: View {
    @Binding var tabSelection: Int
    var body: some View {
        Text("Change tab")
            .onTapGesture {
                tabSelection = 2
            }
    }
}

#Preview {
    oneView(tabSelection: .constant(1))
}
