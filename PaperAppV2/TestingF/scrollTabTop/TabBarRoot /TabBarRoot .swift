//
//  TabBarRoot .swift
//  PaperAppV2
//
//  Created by Sothesom on 06/11/1403.
//

import SwiftUI

struct TabBarRoot_: View {
    @State private var home = UUID()
    @State private var tabSelection = 1
    @State private var swiched: Bool = false
    @State private var course = UUID()
    
    
    var body: some View {
        var handler: Binding<Int> { Binding(
            get: { self.tabSelection },
            set: {
                if $0 == self.tabSelection {
                    swiched = true
                }
                self.tabSelection = $0
            }
        )}
        
        return TabView(selection: handler) {
            NavigationView {
                HomeTestView()
                    .id(home)
                    .onChange(of: swiched, perform: { tapped in
                        guard swiched else { return }
                        home = UUID()
                        swiched = false
                    })
            }
            .tabItem {
                Image(systemName: "square.grid.2x2.fill")
                Text("Learn Now")
            }
            .tag(1)
            
            NavigationView {
                courseTestView()
                    .id(course)
                    .onChange(of: swiched, perform: { tapped in
                        guard swiched else { return }
                        home = UUID()
                        swiched = false
                    })
            }
            .tabItem {
                Image(systemName: "rectangle.stack.fill")
                Text("Courses")
            }
            .tag(2)
        }
    }
}


#Preview {
    TabBarRoot_()
}
