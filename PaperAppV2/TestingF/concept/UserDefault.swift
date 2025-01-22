//
//  UserDefault.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/11/1403.
//

import SwiftUI

struct UserDefault: View {
    let language = UserDefaults.standard.string(forKey: "Language") ?? "Fa"
    var body: some View {
        Text("Language: \(language)")
            .padding()
            .onAppear(){
                let preferredCurrency = "Fa"
                UserDefaults.standard.set(preferredCurrency, forKey: "Language")
            }
    }
}

#Preview {
    UserDefault()
}
