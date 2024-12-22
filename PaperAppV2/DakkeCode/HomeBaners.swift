//
//  HomeBaners.swift
//  PaperApp
//
//  Created by Sothesom on 24/09/1403.
//

import SwiftUI

struct BanereAval: View {
    // View Custom
        @State private var items: [CoverFlowItem] = [ .init(image: Image("3")), .init(image: Image("4")), .init(image: Image("5")),.init(image: Image("6"))
        ]
        
    @State private var spacing: CGFloat = -70
    @State private var rotation: CGFloat = 60
// بازتاب
    @State private var enableReflection: Bool = true
            
    var body: some View {
        VStack{
            CoverFlowView(spacing: spacing, rotation: rotation, enableReflection: enableReflection ,itemWidth: 280, items: items){ item in
                ZStack {
                    NavigationLink(destination: DetailView(item: item)) {
                        item.image
                            .resizable()
                            .frame(width: 280, height: 200)
                            .scaledToFit()
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .frame(height: 200)
        }

    }
}

// --------------------//

struct DetailView: View {
    let item: CoverFlowItem
    
    var body: some View {
        HomeView()
    }
}



//-------------------------------//


struct CardView: View {
    
    @State private var cards: [Card] = [ .init(image: "01"), .init(image: "02"), .init(image: "03"), .init(image: "04"), .init(image: "05"), .init(image: "06")
    ]
    
    var body: some View {
        VStack{
            GeometryReader {
                let size = $0.size
                
                ScrollView(.horizontal){
                    HStack(spacing: 10){
                        ForEach(cards){ card in
                            NavigationLink(destination: DetailView2(item: card)) {
                                CardsView(card)
                                    .frame(height: 100)
                            }
                        }
                    }
                    .padding(.trailing, size.width - 180)
                    .scrollTargetLayout()
                }
    
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
                .clipShape(.rect(cornerRadius: 25))
                
            }
            .padding(.horizontal, 15)
            .padding(.top, 30)
        }
    }
// ٰCards View
    func CardsView(_ card: Card) -> some View {
        GeometryReader{ proxy in
            let size = proxy.size
            let minX = proxy.frame(in: .scrollView).minX
// 190: 180 - Card Width; 10 - Spacing
            let reducingWidth = (minX / 190) * 100
            let cappedWidth = min(reducingWidth, 130)
            
            let frameWidth = max(size.width - (minX > 0 ? cappedWidth : -cappedWidth), 0)

            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .frame(width: frameWidth)
                .clipShape(.rect(cornerRadius: 25))
                .offset(x: minX > 0 ? 0 : -cappedWidth)
                .offset(x: -card.praviousOffset)
        }
        .frame(width: 200, height: 200)
        .offsetXCard{ offset in
            let reducingWidth = (offset / 190) * 100
            let index = cards.indexOf(card)
            
            if cards.indices.contains(index + 1){
                cards[index + 1].praviousOffset = (offset < 0 ? 0 : reducingWidth)
            }

        }
    }
}

// -----------------------------------//

struct DetailView2: View {
    let item: Card
    
    var body: some View {
        ProfileView()
            .padding(.top,90)
            .edgesIgnoringSafeArea(.top)
    }
}


// -------------------------------//


// Custom View
struct CoverFlowView<Content : View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    
    var spacing : CGFloat = 0
    var rotation: Double
    var enableReflection: Bool = false
    var itemWidth: CGFloat
    var items: Item
    var content : (Item.Element) -> Content

    var body: some View {
        
        GeometryReader{
            let size = $0.size
            
            ScrollView(.horizontal){
                LazyHStack(spacing: 5){
                    ForEach(items){ item in
                        content(item)
                            .frame(width: itemWidth)
                            .reflection(enableReflection)
                            .visualEffect { content, geometryProxy in
                                content
//                                    .rotation3DEffect(.init(degrees: rotation(geometryProxy)), axis: (x:0 , y:1, z:0), anchor: .center)
                            }
                            .padding(.trailing, item.id == items.last?.id ? 0 : spacing)
                    }
                }
                .padding(.horizontal, (size.width - itemWidth) / 2)
                .scrollTargetLayout()
            }
            // سکته برای ویوی هر بنر
            .scrollTargetBehavior(.viewAligned)
            // هاید کردن این دست خر پایین اسکرول
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
    
// تابع ریاضی محاسبه این موقعیت های بنر ها نسبت بهم
    func rotation(_ proxy: GeometryProxy) -> Double {
            let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
            let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
    // Converting into progress
            let progress = midX / scrollViewWidth
    // Limiting Progress between 0-1
            let cappedProgress = max(min(progress, 1), 0)
            let degree = cappedProgress * (rotation * 2)
            return rotation - degree
    }
}

    
 

// Cover flow item model
struct CoverFlowItem: Identifiable{
    let id: UUID = .init()
    let image: Image
}


// تابع بازتاب
fileprivate extension View {
    @ViewBuilder
    func reflection(_ added: Bool) -> some View {
        self
            .overlay {
                if added {
                    GeometryReader{
                        let size = $0.size
                        
                        // وارونه کردن
                        self
                            .scaleEffect(y: -1)
                            .mask{
                                Rectangle()
                                    .fill(
                                        .linearGradient(colors: [.white, .white.opacity(0.7), .white.opacity(0.5), .white.opacity(0.3), .white.opacity(0.1), .white.opacity(0)] + Array(repeating: Color.clear, count: 10), startPoint: .top, endPoint: .bottom)
                                    )
                            }
                            .offset(y: size.height + 5)
                            .opacity(0.5)
                    }
                }
            }
        }
    }

// --------------------------//

struct ProfileView: View {
    
    @State private var isProfileExpanded = false
    @Namespace private var profileAnimation
    
    var body: some View {
        ScrollView{
            VStack{
                if isProfileExpanded {
                    expanddedProfileView
                } else {
                    collapadProfileView
                }
                ImagePaper
            }
        }
    }
    
    // Collapad Profile View
    var collapadProfileView: some View{
        HStack{
            profileImage
                .matchedGeometryEffect(id: "Profile", in: profileAnimation)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, content: {
                Text("Gool")
                    .font(.title).bold()
                    .matchedGeometryEffect(id: "Name", in: profileAnimation)
                
                Text("روزنامه ورزشی")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .matchedGeometryEffect(id: "Category", in: profileAnimation)

            })
            .padding(.leading)
            Spacer()
                
        }
        .padding()
    }
    
    // Now we creat view for Expanded Profile
    var expanddedProfileView: some View{
        VStack{
            profileImage
                .matchedGeometryEffect(id: "Profile", in: profileAnimation)
                .frame(width: 130, height: 130)
            
            VStack(spacing: 10){
                Text("Gool")
                    .font(.title).bold()
                    .matchedGeometryEffect(id: "Name", in: profileAnimation)
                
                Text("ورزشی")
                    .foregroundStyle(.secondary)
                    .matchedGeometryEffect(id: "Category", in: profileAnimation)
                
                Text("گل یک روزنامه معتبر ورزشی است که در حوزه تخصصی ورزش و خصوصا فوتبال فعالیت دارد.")
                    .foregroundStyle(.secondary)

                
            }
        }
        .padding()
    }
    
    // we use multiple places profile image so we creat var of profile image. so its easy to maintian and understand
    var profileImage: some View{
        Image("06")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .onTapGesture {
                withAnimation(.spring()){
                    isProfileExpanded.toggle()
                }
            }
    }
    
    // Now we need to add image
    var ImagePaper: some View{
        VStack{
            ForEach(0..<6){ item in
                VStack{
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250)
                .background(.gray.opacity(0.3))
                .clipShape(.rect(cornerRadius: 14))
                .padding()
            }
        }
    }
}
