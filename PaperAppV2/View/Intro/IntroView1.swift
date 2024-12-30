//
//  IntroView1.swift
//  PaperAppV2
//
//  Created by Sothesom on 09/10/1403.
//

import SwiftUI

struct IntroView1: View {
    
    @State private var activePage: IntroModel = .page1
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            
            VStack {
                Spacer(minLength: 0)
                IntroSymbolView(symbol: activePage.rawValue, config: .init(font: .system(size: 150, weight: .bold), frame: .init(width: 250, height: 200), radio:30, forgroudColor: .white))
                
                TexContents(size: size)
                
                Spacer(minLength: 0)
                
                IndicatorView()
                
                ContinueButton()
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .top) {
                HeaderView()
            }
        }
        .background{
            Rectangle()
                .fill(.black.gradient)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func TexContents(size: CGSize) -> some View {
        VStack(spacing: 8){
            HStack(alignment: .top, spacing: 0){
                ForEach(IntroModel.allCases, id: \.rawValue){ page in
                    Text(page.title)
                        .lineLimit(1)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .kerning(1.1)
                        .frame(width: size.width)
                        .foregroundStyle(.white)
                }
            }
            // Sliding Left/Right based on the active
            .offset(x: -activePage.index * size.width)
            .animation(.smooth(duration: 0.7, extraBounce: 0.1), value: activePage)
            
            HStack(alignment: .top, spacing: 0){
                ForEach(IntroModel.allCases, id: \.rawValue){ page in
                    Text(page.subTitel)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(width: size.width)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            // Sliding Left/Right based on the active
            .offset(x: -activePage.index * size.width)
            // adding a little delay
            .animation(.smooth(duration: 0.7, extraBounce: 0.1), value: activePage)
            
            
        }
        .padding(.top, 15)
        .frame(width: size.width, alignment: .leading)
    }
    
    @ViewBuilder
    func IndicatorView() -> some View{
        HStack(spacing: 6){
            ForEach(IntroModel.allCases, id: \.rawValue) { page in
                Capsule()
                    .fill(.white.opacity(activePage == page ? 1 : 0.4))
                    .frame(width: activePage == page ? 25 : 8, height: 8)
            }
        }
        .animation(.smooth(duration: 0.5, extraBounce: 0), value: activePage)
        .padding(.bottom, 12)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
                activePage = activePage.previousPage
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .contentShape(.rect)
            }
            .opacity(activePage != .page1 ? 1 : 0)
            
            Spacer(minLength: 0)
            
            Button("Skip") {
                activePage = .page4
            }
            .fontWeight(.semibold)
            .opacity(activePage != .page4 ? 1 : 0)
        }
        .foregroundStyle(.white)
        .animation(.snappy(duration: 0.35, extraBounce: 0), value: activePage)
        .padding(15)
    }
    
    @ViewBuilder
    func ContinueButton() -> some View {
        Button {
            activePage = activePage.nextPage
        } label: {
            Text(activePage == .page4 ? "Get Started" : "Continue")
                .contentTransition(.identity)
                .foregroundStyle(.black)
                .padding(.vertical, 15)
                .frame(maxWidth: activePage == .page4 ? 220 : 180)
                .background(.white, in: .capsule)
        }
        .padding(.bottom, 15)
        .animation(.smooth(duration: 0.5, extraBounce: 0), value: activePage)
        
    }
}

#Preview {
    IntroView1()
}
