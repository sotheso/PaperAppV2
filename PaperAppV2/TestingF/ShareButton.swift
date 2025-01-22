//
//  ShareButton.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/11/1403.
//

import SwiftUI

struct ShareButton: View {
    var body: some View {
        Button (action: onTob){
            Image(systemName: "square.and.arrow.up")
        }
    }
    
    func onTob() {
        let url = URL(string: "https://t.me/sothesom")
        let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
//        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(activityController, animated: true)
        }
    }
}

#Preview {
    ShareButton()
}
