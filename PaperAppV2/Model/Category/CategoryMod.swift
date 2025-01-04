//
//  CategoryMod.swift
//  PaperApp
//
//  Created by Sothesom on 20/09/1403.
//
import SwiftUI

enum CategoryMod: String, CaseIterable {
    case economic = "Economic"
    case general = "General"
    case sport = "Sport"
    case magazine = "Magazine"
    case All = "All Paper"

    // رنگ‌ها برای هر حالت
    var color: Color {
        switch self {
        case .economic: .blue
        case .general: .green
        case .sport: .red
        case .magazine: .mint
        case .All: Color.primary
        }
    }

    // آیکون‌ها برای هر حالت
    var symbolImage: String {
        switch self {
        case .economic: "dollarsign.circle"
        case .general: "network"
        case .sport: "soccerball"
        case .magazine: "book.circle"
        case .All: "bookmark.circle"
        }
    }
}
