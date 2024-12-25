//
//  TabView.swift
//  PaperApp
//
//  Created by Sothesom on 24/09/1403.
//

import SwiftUI

struct AsliView: View {
    @State private var activeTab : TabMod = .home
    @State private var isTabBarHidden : Bool = false
    
    @State private var searchText: String = ""
    @State private var isSearchActive: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            Group{
                if #available(iOS 18, *) {
                    TabView(selection: $activeTab) {
                        Tab.init(value: .home){
                            HomeView()
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                        Tab.init(value: .category){
                            CategoryView()
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                        Tab.init(value: .notification){
                            Text("notif")
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                        Tab.init(value: .setting){
                            SettingView()
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                    .ignoresSafeArea(.all)
                    
// For iOS low18
                } else {
//                    TabView(selection: $activeTab){
//                        Text("home")
//                            .tag(TabMod.home)
//                            .background{
//                                if !isTabBarHidden {
//                                    HideTabBar{
//                                        print("Hidden")
//                                        isTabBarHidden = true
//                                    }
//                                }
//                            }
//
//                        Text("category")
//                            .tag(TabMod.category)
//
//
//                        Text("nofit")
//                            .tag(TabMod.notification)
//
//
//                        SettingView()
//                            .tag(TabMod.setting)
                }
            }
            TabBarsMod(activeTab: $activeTab)
        }
    }
}

struct HideTabBar: UIViewRepresentable {
    var result: () -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let tabcontroller = view.tabcontroller {
                tabcontroller.tabBar.isHidden = true
                result()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

extension UIView {
    var tabcontroller: UITabBarController? {
        if let controller = sequence(first: self, next: {$0.next
        }).first(where: { $0 is UITabBarController}) as? UITabBarController {
            return controller
        }
        return nil
    }
}
#Preview {
    AsliView()
}
