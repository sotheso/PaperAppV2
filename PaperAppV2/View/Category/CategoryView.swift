//
//  CategoryView.swift
//  PaperApp
//
//  Created by Sothesom on 20/09/1403.
//

import SwiftUI


@available(iOS 18.0, *)
struct CategoryView: View {
    @State private var searchText: String = ""
    @State private var isSearchActive: Bool = false
    
    @State private var activeTab: CategoryMod = .All
    
    @State private var scrollOffset: CGFloat = 0
    @State private var topInset: CGFloat = 10
    
    @State private var startTopInsert: CGFloat = 0
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(spacing: 0){
                    CustomTabBar(activeTab: $activeTab)
                        .frame(height: isSearchActive ? 0 : nil, alignment: .top)
                        .opacity(isSearchActive ? 0 : 10)
                        .padding(.vertical, isSearchActive ? 0 : 10)
                        .background{
                            let progress = min(max((scrollOffset + startTopInsert - 110) / 15, 0), 1)
                            
                            ZStack(alignment: .bottom){
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                
                                Rectangle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(height: 1)
                            }
                            .padding(.top, -topInset)
                            .padding(progress)
                        }
                        .offset(y: (scrollOffset + topInset) > 0 ? (scrollOffset + topInset) : 0)
                        .zIndex(1000)
                    
                    GradView()
                        .padding(10)
                        .zIndex(0)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isSearchActive)
            .navigationTitle("Category View")
            .searchable(text: $searchText, isPresented: $isSearchActive, placement: .navigationBarDrawer(displayMode: .automatic))
// برای چسبیدن دسته ها به بالای صفحه موقع اسکرول کردن
            .onScrollGeometryChange(for: CGFloat.self, of: {
                $0.contentOffset.y
            }, action: { oldValue , newValue in
                scrollOffset = newValue
            })
            .onScrollGeometryChange(for: CGFloat.self, of: {
                $0.contentInsets.top
            }, action: { oldValue , newValue in
                if startTopInsert == .zero {
                    startTopInsert = newValue
                }
                topInset = newValue
            })
        }
        
    }
}
struct CustomTabBar: View {
    @Binding var activeTab: CategoryMod
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        GeometryReader { _ in
            HStack(spacing: 8) {
                HStack(spacing: activeTab == .All ? -15 : 8) {
                    // استفاده از allCases به جای CaseIterable
                    ForEach(CategoryMod.allCases.filter({ $0 != .All}), id: \.rawValue) { tab in
                        ResizevleTabButton(tab)
                    }
                }
                if activeTab == .All{
                    ResizevleTabButton(.All)
                        .transition(.offset(x:200))
                }
            }
            .padding(.horizontal, 15)
        }
        .frame(height: 50)
    }

// کلید های دسته بندی ها
    @ViewBuilder
    func ResizevleTabButton(_ tab: CategoryMod) -> some View {
        HStack(spacing: 8) {
            Image(systemName: tab.symbolImage)
                .opacity(activeTab != tab ? 1 : 0)
            // For animation
                .overlay {
                    Image(systemName: tab.symbolImage)
                        .symbolVariant(.fill)
                        .opacity(activeTab == tab ? 1 : 0)
                }

            if activeTab == tab {
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(tab == .All ? schemeColor : activeTab == tab ? .white : .gray)
        .frame(maxHeight: .infinity)
        .frame(maxWidth: activeTab == tab ? .infinity: nil)
        .padding(.horizontal, activeTab == tab ? 10 : 20)
        .background {
            Rectangle()
                .fill(activeTab == tab ? tab.color : .gray.opacity(0.16))
        }
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .background{
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.background)
                .padding(activeTab == .All && tab != .All ? -3 : 3)
        }
        .contentShape(.rect)
        .onTapGesture {
            guard tab != .All else { return }
            withAnimation(.bouncy){
                if activeTab == tab {
                    activeTab = .All
                } else {
                    activeTab = tab
                }
            }
        }
    }
    var schemeColor: Color {
        scheme == .dark ? .black : .white
    }
}

struct GradView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(0..<25) { item in
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 180, height: 220)
                    .foregroundStyle(.ultraThinMaterial)
            }
        }
        .padding(.horizontal, 10)
    }
}
#Preview {
    CategoryView()
}
