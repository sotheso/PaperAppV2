//
//  IntroSymbolView.swift
//  PaperAppV2
//
//  Created by Sothesom on 09/10/1403.
//

import SwiftUI

struct IntroSymbolView: View {
    
    var symbol: String
    var config: Config
    
    @State private var trigger: Bool = false
    @State private var displayingSymbol: String = ""
    @State private var newSymbol: String = ""
    
    var body: some View {
        Canvas { ctx , size in
            ctx.addFilter(.alphaThreshold(min: 0.4, color: config.forgroudColor))
            
            if let renderadImage = ctx.resolveSymbol(id: 0){
                ctx.draw(renderadImage, at: CGPoint(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            ImageView()
                .tag(0)
            
        }
        .frame(width: config.frame.width, height: config.frame.height)
        .onChange(of: symbol) { oldValue, newValue in
            trigger.toggle()
            newSymbol = newValue
        }
        .task {
            guard displayingSymbol == ""  else { return }
            displayingSymbol = symbol
        }
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        KeyframeAnimator(initialValue: CGFloat.zero, trigger: trigger){ redius in
            Image(systemName: displayingSymbol)
                .font(config.font)
                .foregroundStyle(config.forgroudColor)
                .blur(radius: redius)
                .frame(width: config.frame.width, height: config.frame.height)
                .onChange(of: redius) { oldValue, newValue in
                    if newValue.rounded() == config.radio {
                        // Animation Symbol Change
                        withAnimation(config.symbolAnimation){
                            displayingSymbol = newSymbol
                        }
                    }
                }
        } keyframes: { _ in
            CubicKeyframe(config.radio, duration: config.keyFrameDuration)
            CubicKeyframe(0, duration: config.keyFrameDuration)
        }
            
    }
    
    struct Config {
        var font: Font
        var frame: CGSize
        var radio: CGFloat
        var forgroudColor: Color
        var keyFrameDuration: CGFloat = 0.4
        var symbolAnimation: Animation = .smooth(duration: 0.5, extraBounce: 0)
    }
}

#Preview {
    IntroSymbolView(symbol: "gearshape.fill", config: .init(font: .system(size: 100, weight: .bold), frame: CGSize(width: 250, height: 200), radio: 15, forgroudColor: .black))
}
