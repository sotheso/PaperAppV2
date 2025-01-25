//
//  HomeTestView.swift
//  PaperAppV2
//
//  Created by Sothesom on 06/11/1403.
//

import SwiftUI

struct courseTestView: View {
    var columns = [GridItem(.adaptive(minimum: 159), spacing: 16)]
    var body: some View {
        ScrollView {
            Text("course")
                .font(.largeTitle).bold()
                .padding(.horizontal, 20)
                .padding(.top, 17)
                .id(1)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<10) { number in
                    NavigationLink(destination: childTset(courseTitle: "test")) {
                        sampleCard(image: "illustration", title: "SwiftUI for iOS 14", hours: "20 sections - 3 hours", colors: [Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1))], logo: "swift-logo")
                    }
                }
            }
            .padding(20)
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    HomeTestView()
}
