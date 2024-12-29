//
//  ViewHomeS1.swift
//  PaperAppV2
//
//  Created by Sothesom on 09/10/1403.
//

import SwiftUI

struct ViewHomeS1<Content: View>: View {
    @ViewBuilder var content: Content
    
    @State private var scrollPosition: Int?
    @State private var isScrolling: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    Group(subviews: content) { collection in
                        
                        if let lasItem = collection.last {
                            lasItem
                                .frame(width: size.width, height: size.height)
                                .id(-1)
                                .onChange(of: isScrolling) { oldValue, newValue in
                                    if !newValue && scrollPosition == -1 {
                                        scrollPosition = collection.count - 1
                                    }
                                }
                        }
                        
                        ForEach(collection.indices, id: \.self) { index in
                            collection[index]
                                .frame(width: size.width, height: size.height)
                                .id(index)
                        }
                        
                        if let firstItem = collection.last {
                            firstItem
                                .frame(width: size.width, height: size.height)
                                .id(collection.count)
                                .onChange(of: isScrolling) { oldValue, newValue in
                                    if !newValue && scrollPosition == collection.count {
                                        scrollPosition = 0
                                    }
                                }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollPosition)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .onScrollPhaseChange{ oldPhase, newPhase in
                isScrolling = newPhase.isScrolling
            }
            .onAppear{ scrollPosition = 0 }
        }
    }
}

#Preview {
    ViewHomeS()
}
