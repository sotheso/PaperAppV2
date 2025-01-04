//
//  ViewHomeS2Mod.swift
//  PaperAppV2
//
//  Created by Sothesom on 15/10/1403.
//

import SwiftUI

struct NofitMod: Identifiable {
    var id: String = UUID().uuidString
    var altText: String
    var image: String
}

let imageNotif: [NofitMod] = [
    .init(altText: "test1", image: "01"),
    .init(altText: "test2", image: "02"),
    .init(altText: "test3", image: "03"),
    .init(altText: "test4", image: "04"),
    .init(altText: "test5", image: "05"),
    .init(altText: "test6", image: "06")
]
