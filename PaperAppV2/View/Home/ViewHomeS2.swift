//
//  ViewHomeS2.swift
//  PaperAppV2
//
//  Created by Sothesom on 15/10/1403.
//

import SwiftUI

struct ViewHomeS2: View {
    @State private var topInset: CGFloat = 0
    @State private var scrollOffsetY: CGFloat = 0
    @State private var scrollProgressX: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical){
            LazyVStack(spacing: 15){
                HeaderView()
                
                CarouselView()
                // placing at the lowest of all views
                    .zIndex(-1)
            }
        }
        .safeAreaPadding(15)
        
        .background{
            Rectangle()
                .fill(.black.gradient)
                .scaleEffect(y: -1)
                .ignoresSafeArea()
        }
        // بالا کشیدن افکت محو
        .onScrollGeometryChange(for: ScrollGeometry.self) {
            $0
        } action: { oldValue, newValue in
            /// The value 100 represents the approximate height of the header view, including the spacings. If you have a larger view at the top of the carousel, calculate the height accordingly. Alternatively, you can use the Geometry Reader to find the minY value
            topInset = newValue.contentInsets.top + 100
            
            scrollOffsetY = newValue.contentOffset.y + newValue.contentInsets.top
        }
    }
        
    @ViewBuilder
    func HeaderView() -> some View{
        HStack {
            Image(systemName: "xbox.logo")
                .font(.system(size: 35))
            
            
            VStack(alignment:.leading, spacing: 4){
                Text("Sothesom")
                    .font(.callout)
                    .fontWeight(.semibold)
                
                HStack(spacing: 6){
                    Image(systemName: "g.circle.fill")
                    
                    Text("11.33")
                        .font(.callout)
                }
            }
            
            Spacer(minLength: 0)
            
            Image(systemName: "square.and.arrow.up.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white, .fill)
            
            Image(systemName: "bell.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white, .fill)
        }
        .padding(.bottom, 15)
    }
    
    @ViewBuilder
    func CarouselView() -> some View{
        let spacing: CGFloat = 4

        ScrollView(.horizontal){
            LazyHStack(spacing: spacing) {
                ForEach(ViewHomeS3) { model in
                    Image(model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame(.horizontal)
                        .frame(height: 300)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.4), radius: 5, x:5, y: 5)
                }
            }
            .scrollTargetLayout()
            
        }
        .frame(height: 300)
        .background(BackropCarosuelView())
        .scrollIndicators(.hidden)
        // حالت اسنپی در زمان اسکرول حتی با سرعت بالا
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        
        .onScrollGeometryChange(for: CGFloat.self){
            let offsetX = $0.contentOffset.x + $0.contentInsets.leading
            let width = $0.contentSize.width + spacing
            
            return offsetX / width
        } action: { oldValue , newValue in
            let maxValue = CGFloat(ViewHomeS3.count - 1)
            scrollProgressX = min(max(newValue, 0), maxValue)
        }
    }
    
    @ViewBuilder
    func BackropCarosuelView() -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack{
                ForEach(ViewHomeS3.reversed()) { model in
                    let index = CGFloat(ViewHomeS3.firstIndex(where: { $0.id == model.id }) ?? 0) + 1
                    
                    Image(model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .opacity(index - scrollProgressX)
                }
            }
            .compositingGroup()
            .blur(radius: 20, opaque: true)
            .overlay{
                Rectangle()
                    .fill(.black.opacity(0.35))
            }
            .mask{
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .black,
                        .black,
                        .black,
                        .black,
                        .black.opacity(0.5),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
            }
        }
        //// Using Container Relative Frame Modifier, to make it occupy full available width
        .containerRelativeFrame(.horizontal)
        /// Extending the bottom side slightly more will enhance the progressive effect and make it appear more completel
        .padding(.bottom, -60)
        .padding(.top, -topInset)
        .offset(y: scrollOffsetY < 0 ? scrollOffsetY : 0)
        
    }
}

#Preview {
    NotifView()
}
