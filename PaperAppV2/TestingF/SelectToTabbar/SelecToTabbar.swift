//
//  SelecToTabbar.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/11/1403.
//
// برای جابجایی بین تب ها بدون استفاده از دکمه تب بار پایین

import SwiftUI

struct SelecToTabbar: View {
    @State var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection ) {
            oneView(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Home") }
                .tag(1)
            
            SecondView(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "rectangle.stack.fill")
                    Text("Settings")
                }
                .tag(2)
        }
    }
}

#Preview {
    SelecToTabbar()
}
