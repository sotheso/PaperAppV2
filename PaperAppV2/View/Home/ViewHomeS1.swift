//
//  ViewHomeS1.swift
//  PaperAppV2
//
//  Created by Sothesom on 09/10/1403.
//

import SwiftUI

struct ViewHomeS1<Content: View>: View {
    @Binding var activeIndex: Int
    
    @ViewBuilder var content: Content
    
    @State private var scrollPosition: Int?
    @State private var offsetBasedScreen: Bool = false
    @State private var isSettled: Bool = false
    
    @State private var isScrolling: Bool = false
    
    // دست خر زیرش
    @GestureState private var isHoldingScreen: Bool = false
    @State private var timer = Timer.publish(every: autoSrollDuration, on: .main, in: .default).autoconnect()
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            Group(subviews: content) { collection in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        if let lasItem = collection.last {
                            lasItem
                                .frame(width: size.width, height: size.height)
                                .id(-1)
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
                            
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrollPosition)
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                
                .onScrollPhaseChange{ oldPhase, newPhase in
                    isScrolling = newPhase.isScrolling
                    if  !isScrolling && scrollPosition == -1 {
                        scrollPosition = collection.count - 1
                    }
                    
                    if !isScrolling && scrollPosition == collection.count && !isHoldingScreen {
                        scrollPosition = 0
                    }
                }
                
                .simultaneousGesture(DragGesture(minimumDistance: 0).updating($isHoldingScreen, body: {
                    _ , state, _ in
                    state = true
                }))
                
                .onChange(of: isHoldingScreen, { oldValue , newValue in
                    if newValue {
                        timer.upstream.connect().cancel()
                        
                    } else {
                        if isSettled && scrollPosition != offsetBasedScreen {
                            scrollPosition = offsetBasedScreen
                        }
                        
                        timer = Timer.publish(every: Self.autoSrollDuration, on: .main, in: .default).autoconnect()
                    }
                })
                
                .onReceive(timer) { _ in
                    guard !isHoldingScreen && isScrolling else { return }
                    
                    let nextIndex = (scrollPosition ?? 0) + 1
                    
                    withAnimation(.snappy(duration: 0.5, extraBounce: 0)) {
                        scrollPosition = (nextIndex == collection.count) ? 0 : nextIndex
                        
                    }
                }
                
                .onChange(of: scrollPosition) { oldValue, newValue in
                    if let newValue {
                        if newValue == -1 {
                            activeIndex = collection.count - 1
                        } else if newValue == collection.count {
                            activeIndex = 0
                        } else {
                            activeIndex = max(min(newValue, collection.count - 1), 0)
                        }
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) {
                    $0.contentOffset.x
                } action: { oldValue ,newValue in
                    
                    isSettled = size.width > 0 ? (Int(newValue) % Int(size.width) == 0) : false
                    let index = size.width > 0 ? Int((newValue / size.width).rounded() - 1) : 0
                    offsetBasedScreen = index
                    
                    if isSettled  && (scrollPosition != index || index == collection.count) && !isHoldingScreen {
                        scrollPosition = index == collection.count ? -0 : index
                    }
                }
            }
            .onAppear{ scrollPosition = 0 }
        }
    }

    
    
    static var autoSrollDuration: CGFloat {
        return 1
    }
}

#Preview {
    ViewHomeS()
}
