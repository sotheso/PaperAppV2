//
//  childTset.swift
//  PaperAppV2
//
//  Created by Sothesom on 06/11/1403.
//

import SwiftUI

struct childTset: View {
    var courseTitle: String
    
    var body: some View {
        VStack {
            Text(courseTitle)
                .font(.title).bold()
                .padding()
            
            Text("This is the child view.")
        }
    }

}

#Preview {
    childTset(courseTitle: "sothesom")
}
