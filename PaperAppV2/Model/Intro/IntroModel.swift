//
//  IntroModel.swift
//  PaperAppV2
//
//  Created by Sothesom on 09/10/1403.
//

import SwiftUI

enum IntroModel: String, CaseIterable{
    case page1 = "playstation.logo"
    case page2 = "gamecontroller.fill"
    case page3 = "link.icloud.fill"
    case page4 = "text.bubble.fill"
    
    var title: String {
        switch self {
        case .page1:
            "Welcome to PaparApp"
        case .page2:
            "Lurem 2"
        case .page3:
            "Lurem 3"
        case .page4:
            "Lurem 4"
        }
    }
    
    var subTitel: String {
        switch self {
        case .page1:
            "you joury starts here"
        case .page2:
            "Lurem22"
        case .page3:
            "Lurem33"
        case .page4:
            "Lurem44"
        }
    }
    
    var index: CGFloat {
        switch self {
        case .page1:
            0
        case .page2:
            1
        case .page3:
            2
        case .page4:
            3
        }
    }
    
    var nextPage: IntroModel {
        let index = Int(self.index) + 1
        if index < 4 {
            return IntroModel.allCases[index]
        }
        
        return self
    }
    
    var previousPage: IntroModel {
        let index = Int(self.index) - 1
        if index >= 0 {
            return IntroModel.allCases[index]
        }
        
        return self
    }
}
