//
//  PaperMod.swift
//  PaperAppV2
//
//  Created by Sothesom on 08/10/1403.
//

import Foundation
import FirebaseFirestore
import SwiftUICore
import SwiftUI

struct PaperMod: Identifiable, Codable {
    // اطلاعات اصلی روزنامه
    @DocumentID var id: String?
    var title: String
    var subtitle: String?
    var content: String?
    
    // اطلاعات مدیا
    var coverImageURL: String?
    var imagesURL: [String]?
    
    // دستبندی و تگ
    var category: PaperCategory
    var tags: [String]?
    
    // اطلاعات زمانی
    var publishDate: Date
    var updateDate: Date?
    
    // اطلاعات ناشر
    var publisherName: String
    var publisherID: String
    
    // آمار
    var viewCount: Int
    var likeCount: Int
    
    enum PaperCategory: String, CaseIterable, Codable {
        // دسته\u{20c}های اصلی روزنامه\u{20c}ها
        case news = "News"
        case sports = "Sports"
        case politics = "Politics"
        case economy = "Economy"
        case culture = "Culture"
        case technology = "Technology"
        case entertainment = "Entertainment"
        case lifestyle = "Lifestyle"
        case international = "International"
        
        // رنگ مخصوص هر دسته\u{20c}بندی
        var color: Color {
            switch self {
            case .news: return .blue
            case .sports: return .red
            case .politics: return .purple
            case .economy: return .green
            case .culture: return .orange
            case .technology: return .mint
            case .entertainment: return .pink
            case .lifestyle: return .teal
            case .international: return .indigo
            }
        }
        
        // آیکون مخصوص هر دسته\u{20c}بندی
        var icon: String {
            switch self {
            case .news: return "newspaper"
            case .sports: return "figure.american.football"
            case .politics: return "building.columns"
            case .economy: return "chart.line.uptrend.xyaxis"
            case .culture: return "books.vertical"
            case .technology: return "laptopcomputer"
            case .entertainment: return "tv"
            case .lifestyle: return "heart"
            case .international: return "globe"
            }
        }
        
        enum NewspaperCategory: String, CaseIterable, Codable {
            // دسته\u{20c}های اصلی روزنامه\u{20c}ها
            case news = "News"
            case sports = "Sports"
            case politics = "Politics"
            case economy = "Economy"
            case culture = "Culture"
            case technology = "Technology"
            case entertainment = "Entertainment"
            case lifestyle = "Lifestyle"
            case international = "International"
            
            // رنگ مخصوص هر دسته\u{20c}بندی
            var color: Color {
                switch self {
                case .news: return .blue
                case .sports: return .red
                case .politics: return .purple
                case .economy: return .green
                case .culture: return .orange
                case .technology: return .mint
                case .entertainment: return .pink
                case .lifestyle: return .teal
                case .international: return .indigo
                }
            }
            
            // آیکون مخصوص هر دسته\u{20c}بندی
            var icon: String {
                switch self {
                case .news: return "newspaper"
                case .sports: return "figure.american.football"
                case .politics: return "building.columns"
                case .economy: return "chart.line.uptrend.xyaxis"
                case .culture: return "books.vertical"
                case .technology: return "laptopcomputer"
                case .entertainment: return "tv"
                case .lifestyle: return "heart"
                case .international: return "globe"
                }
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case content
        case coverImageURL
        case imagesURL
        case category
        case tags
        case publishDate
        case updateDate
        case publisherName
        case publisherID
        case viewCount
        case likeCount
    }

    
}


