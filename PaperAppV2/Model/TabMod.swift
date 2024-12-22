//
//  Tab.swift
//  PaperApp
//
//  Created by Sothesom on 24/09/1403.
//

import SwiftUI

enum TabMod: String , CaseIterable {
    case home = "house"
    case category = "map.fill"
    case notification = "bell"
    case setting = "gearshape"
    
    var title: String {
        switch self {
        case .home:
            "Home"
        case .category:
            "Search"
        case .notification:
            "Notification"
        case .setting:
            "Setting"
        }
    }
}
