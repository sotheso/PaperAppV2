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
    @State private var offsetBasedScreen: Int = 0
    @State private var isSettled: Bool = false
    @State private var isScrolling: Bool = false
    @GestureState private var isHoldingScreen: Bool = false
    @State private var timer = Timer.publish(every: autoSrollDuration, on: .main, in: .default).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            Group(subviews: content) { collection in
                let contentView = HStack(spacing: 0) {
                    // Main content
                    ForEach(collection.indices, id: \ .self) { index in
                        collection[index]
                            .frame(width: size.width, height: size.height)
                            .id(index)
                    }

                    // Additional dummy view for infinite scroll simulation
                    if let firstItem = collection.first{
                        AnyView (firstItem)
                            .frame(width: size.width, height: size.height)
                            .id(collection.count)
                    }
                }
                .scrollTargetLayout()

                ScrollView(.horizontal) {
                    contentView
                }
                .scrollPosition(id: $scrollPosition)
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .onScrollPhaseChange { oldPhase, newPhase in
                    handleScrollPhaseChange(newPhase, collectionCount: collection.count)
                }
                .simultaneousGesture(DragGesture(minimumDistance: 0).updating($isHoldingScreen) { _, state, _ in
                    state = true
                })
                .onChange(of: isHoldingScreen) {
                    handleHoldingScreenChange($1)
                }
                .onReceive(timer) { _ in
                    handleTimerTick(collectionCount: collection.count)
                }
                .onChange(of: scrollPosition) {
                    handleScrollPositionChange($1 , collectionCount: collection.count)
                }
                .onScrollGeometryChange(for: CGFloat.self) {
                    $0.contentOffset.x
                } action: { _, newValue in
                    handleScrollGeometryChange(newValue, size: size, collectionCount: collection.count)
                }
            }
            .onAppear { scrollPosition = 0 }
        }
    }

    private func handleScrollPhaseChange(_ newPhase: ScrollPhase, collectionCount: Int) {
        isScrolling = newPhase.isScrolling
        if !isScrolling && scrollPosition == -1 {
            scrollPosition = 0
        }
        if !isScrolling && scrollPosition == collectionCount && !isHoldingScreen {
            scrollPosition = 0
        }
    }

    private func handleHoldingScreenChange(_ newValue: Bool) {
        if newValue {
            timer.upstream.connect().cancel()
        } else {
            if isSettled && scrollPosition != offsetBasedScreen {
                scrollPosition = offsetBasedScreen
            }
            timer = Timer.publish(every: Self.autoSrollDuration, on: .main, in: .default).autoconnect()
        }
    }

    private func handleTimerTick(collectionCount: Int) {
        guard !isHoldingScreen && !isScrolling else { return }
        let nextIndex = (scrollPosition ?? 0) + 1
        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
            scrollPosition = (nextIndex == collectionCount) ? 0 : nextIndex
        }
    }

    private func handleScrollPositionChange(_ newValue: Int?, collectionCount: Int) {
        if let newValue {
            if newValue == -1 {
                activeIndex = collectionCount - 1
            } else if newValue == collectionCount {
                activeIndex = 0
            } else {
                activeIndex = max(min(newValue, collectionCount - 1), 0)
            }
        }
    }

    private func handleScrollGeometryChange(_ newValue: CGFloat, size: CGSize, collectionCount: Int) {
        isSettled = size.width > 0 ? (Int(newValue) % Int(size.width) == 0) : false
        let index = size.width > 0 ? Int((newValue / size.width).rounded() - 1) : 0
        offsetBasedScreen = index

        if isSettled && (scrollPosition != index || index == collectionCount) && !isScrolling && !isHoldingScreen {
            scrollPosition = index == collectionCount ? 0 : index
        }
    }

    static var autoSrollDuration: CGFloat {
        return 2
    }
}

#Preview {
    ViewHomeS()
}
