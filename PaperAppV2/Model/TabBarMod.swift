//
//  CustomTabBar.swift
//  PaperApp
//
//  Created by Sothesom on 24/09/1403.
//

import SwiftUI

struct TabBarsMod: View {
    var activeForgraound: Color = .white
    var activeBackground: Color = .blue
    
    
    @Binding var activeTab: TabMod
    // For gemetry effect
    @Namespace private var animation
    
    @State private var tabLocation: CGRect = CGRect(x: 0, y: 0, width: 50, height: 30) // مقدار پیش‌فرض
    
    
    var body: some View {
        
        // وقتی میره توی دوتا تب غیر از دستبندی و خانه دکمه سمت راست محو بشه
        let status = activeTab == .home || activeTab == .category
        
        HStack(spacing: !status ? 0 : 12) {
            HStack(spacing: 0) {
                ForEach(TabMod.allCases, id: \.rawValue) { tab in
                    Button {
                        activeTab = tab
                    } label: {
                        HStack(spacing: 5){
                            Image(systemName: tab.rawValue)
                                .font(.title3)
                                .frame(width: 30, height: 30)
                            
                            if activeTab == tab {
                                Text(tab.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundStyle(activeTab == tab ? activeForgraound : .gray)
                        .padding(.vertical, 2)
                        .padding(.leading, 10)
                        .padding(.trailing, 15)
                        .contentShape(.rect)
                        .background{
                            if activeTab == tab {
                                Capsule()
                                    .fill(.clear)
                                    .onGeometryChange(for: CGRect.self, of:
                                                        { $0.frame(in: .named("TABACTiv"))  }, action:{ newValue in
                                        tabLocation = newValue
                                    })
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                            
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .edgesIgnoringSafeArea(.bottom) 
            .background(alignment: .leading){
                Capsule()
                    .fill(activeBackground.gradient)
                    .frame(width: tabLocation.width, height: tabLocation.height)
                    .offset(x: tabLocation.minX)
            }
            .coordinateSpace(.named("TABACTiv"))
            .padding(.horizontal, 5)
            .frame(height: 45)
            .background(
                .background
                    .shadow(.drop(color: .black.opacity(0.08), radius:5, x:5, y:5))
                    .shadow(.drop(color: .black.opacity(0.06), radius:5, x:-5, y:-5)),
                in: .capsule
            )
            .zIndex(10)
                        
            // دکمه سمت راست
            Button {
                
            } label: {
                Image(systemName: activeTab == .home ? "person.fill" : "slider.vertical.3")
                    .font(.title3)
                    .frame(width: 42, height: 42)
                    .foregroundStyle(activeForgraound)
                    .background(activeBackground.gradient)
                    .clipShape(.circle)
            }
            .allowsHitTesting(status)
            .offset(x: status ? 0 : -20)
            .padding(.leading, status ? 0 : -42)
        }
        .padding(.bottom, 5)
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
        
    };
}

#Preview {
    AsliView()
}
